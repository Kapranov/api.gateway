defmodule Connector.IntertelecomHandler do
  @moduledoc """
  Intertelecom external api calls.
  """

  use GenServer

  alias Core.{
    Repo,
    Spring.Message
  }

  @action "post"
  @connector :intertelecom
  @headers %{"content-type" => "application/json"}
  @name __MODULE__
  @options []
  @timeout 1_000

  @spec start_link([{String.t()}]) :: {atom(), pid} | atom()
  def start_link([{args}]) do
      GenServer.start_link(@name, args, name: @name)
    catch
      :exit, _reason -> :error
  end

  @spec get_status(pid()) :: map() | atom()
  def get_status(pid) when is_pid(pid) do
      :sys.get_state(pid)
    catch
      :exit, _reason -> :timeout
  end

  @spec stop(pid) :: :ok | :error
  def stop(pid) do
      GenServer.stop(pid, :normal, @timeout)
    catch
      :exit, _reason -> :error
  end

  @spec init(String.t()) :: {atom(), String.t(), {:continue, atom()}}
  def init(message_id) do
    schedule_work()
    {:ok, message_id, {:continue, :fetch_from_db}}
  end

  @spec handle_continue(atom(), String.t()) ::
        {:noreply, atom(), {:continue, atom()}} |
        {:noreply, map(), {:continue, atom()}}
  def handle_continue(:fetch_from_db, message_id) do
    case check_id(message_id) do
      nil ->
        {:noreply, :error, {:continue, :none_record}}
      struct ->
        state = %{
          id: struct.id,
          message_body: struct.message_body,
          phone_number: struct.phone_number
        }
        {:noreply, state, {:continue, :found}}
    end
  end

  @spec handle_continue(atom(), atom()) :: {:noreply, atom()}
  def handle_continue(:none_record, state) do
    self() |> send(:more_init)
    {:noreply, state}
  end

  @spec handle_continue(atom(), map()) :: {:noreply, map()}
  def handle_continue(:found, state) do
    case get_request(@action, state) do
      {:ok, response} ->
        {:noreply, response, {:continue, :created_table}}
      {:error, response} ->
        {:noreply, response}
    end
  end

  @spec handle_continue(atom(), map()) ::
        {:noreply, map(), {:continue, atom()}} |
        {:noreply, atom()}
  def handle_continue(:created_table, state) do
    :ets.new(@connector, [:set, :public, :named_table])
    case is_list(:ets.info(@connector)) do
      true ->
        try do
          :ets.insert(@connector, {state.id, state.status, @connector})
          IO.puts("Received arguments: #{inspect(state)}")
          {:noreply, state, {:continue, :updated_table}}
        rescue
          ArgumentError -> {:noreply, :error}
        end
      false -> {:noreply, :error}
    end
  end

  @spec handle_continue(atom(), map()) ::
        {:noreply, map()} |
        {:noreply, atom()}
  def handle_continue(:updated_table, state) do
    case is_list(:ets.info(@connector)) do
      true ->
        try do
          if :ets.lookup_element(@connector, state.id, 1) == state.id do
            Enum.reduce(status_names(), [], fn(x, acc) ->
              case x do
                :delivered ->
                  :ets.update_element(@connector, state.id, {2, "delivered"})
                  [{id, status, connector}] = :ets.lookup(@connector, state.id)
                  new_state = %{
                    connector: Atom.to_string(connector),
                    id: id,
                    sms: state.sms,
                    status: status,
                    text: state.text
                  }
                  Connector.Timeout.new(1_000, backoff: 1.25, backoff_max: 1_250, random: 0.1)
                  |> Connector.Timeout.send_after(self(), :updated_ets)
                  {:noreply, new_state}
                :error ->
                  Process.sleep(1_000)
                  acc
                :send ->
                  Process.sleep(1_000)
                  acc
              end
            end)
          else
            {:noreply, :error}
          end
        rescue
          ArgumentError -> {:noreply, :error}
        end
      false -> {:noreply, :error}
    end
  end

  @spec handle_continue(any(), map() | atom()) :: {:noreply, map()} | {:noreply, atom()}
  def handle_continue(_args, state) do
    {:noreply, state}
  end

  @spec handle_info(atom(), map() | atom() ) :: {:noreply, map()} | {:noreply, atom()}
  def handle_info(:more_init, state) do
    schedule_work()
    {:noreply, state}
  end

  @spec handle_info(atom(), map()) :: {:noreply, map()} | {:noreply, atom()}
  def handle_info(:found, state) do
    IO.puts("Received arguments: #{inspect(state)}")
    {:noreply, state}
  end

  @spec handle_info(atom(), map()) :: {:noreply, map()} | {:noreply, atom()}
  def handle_info(:created_ets, state) do
    IO.puts("Received arguments: #{inspect(state)}")
    {:noreply, state}
  end

  @spec handle_info(atom(), map()) :: {:noreply, map()} | {:noreply, atom()}
  def handle_info(:updated_ets, state) do
    IO.puts("Received arguments: #{inspect(state)}")
    {:noreply, state}
  end

  @spec handle_info(any(), map()) :: {:noreply, map()} | {:noreply, atom()}
  def handle_info(_msg, state) do
    IO.puts("Received arguments: #{inspect(state)}")
    {:noreply, state}
  end

  @spec terminate(any(), any()) :: atom()
  def terminate(_reason, _state), do: :ok

  @spec schedule_work() :: reference()
  defp schedule_work do
    Process.send_after(self(), :more_init, 250)
  end

  @spec check_id(String.t()) :: Message.t() | nil
  defp check_id(id), do: Repo.get(Message, id)

  @spec get_request(String.t(), map()) :: {:ok, map()} | {:error, atom()}
  defp get_request(action, data) do
    body = URI.encode_query(%{
      "id" => data.id,
      "sms" => data.phone_number,
      "status" => "send",
      "text" => data.message_body
    })
    url = api_route(action)
    case HTTPoison.post(url, body, @headers, @options) do
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
      {:ok, %HTTPoison.Response{body: body}} ->
        state = decode(body)
        timer(1_000)
        {:ok, state}
    end
  end

  @spec api_route(String.t()) :: String.t()
  defp api_route(action), do: "http://httpbin.org/#{action}"

  @spec decode(map()) :: map()
  defp decode(data) do
    struct =
      data
      |> Jason.decode!
      |> Map.get("data")
      |> URI.decode_query

    %{
      connector: Atom.to_string(@connector),
      id: struct["id"],
      sms: struct["sms"],
      status: struct["status"],
      text: struct["text"]
    }
  end

  @spec timer(non_neg_integer()) :: non_neg_integer()
  defp timer(num) do
    Enum.random(num..4_000)
    |> Process.sleep()
  end

  @spec status_names() :: [atom()]
  defp status_names do
    names = ~W(delivered error send)a
    names
  end
end
