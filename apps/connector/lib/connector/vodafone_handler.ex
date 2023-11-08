defmodule Connector.VodafoneHandler do
  @moduledoc """
  Vodafone external api calls.
  """

  use GenServer

  alias Core.{
    Repo,
    Spring.Message
  }

  @action "post"
  @headers %{"content-type" => "application/json"}
  @name __MODULE__
  @options []
  @timeout 3_000

  @spec start_link([{String.t()}]) :: {atom(), pid} | atom()
  def start_link([{args}]) do
      GenServer.start_link(@name, args, name: @name)
    catch
      :exit, _reason -> :timeout
  end

  @spec get_status(String.t()) :: map() | atom()
  def get_status(message_id) do
      GenServer.call(@name, {:get_status, message_id})
    catch :exit, _reason -> :timeout
  end

  @spec get_status(pid(), non_neg_integer()) :: map() | atom()
  def get_status(pid, timeout) do
    timeout |> Process.sleep()
      :sys.get_state(pid)
    catch
      :exit, _reason -> :timeout
  end

  @spec stop(pid) :: :ok | :none
  def stop(pid) do
      GenServer.stop(pid, :normal, @timeout)
    catch
      :exit, _reason -> :none
  end

  @spec init(String.t()) :: {atom(), String.t(), {:continue, atom()}}
  def init(message_id) do
    schedule_work()
    {:ok, message_id, {:continue, :fetch_from_db}}
  end

  @spec handle_call({atom(), String.t()}, any(), map() | atom()) ::
        {:reply, atom(), String.t()} |
        {:reply, map(), String.t()} |
        {:noreply, atom()}
  def handle_call({:get_status, message_id}, _pid, state) do
    case check_id(message_id) do
      nil ->
        {:reply, :error, state}
      struct ->
        data = %{
          id: struct.id,
          message_body: struct.message_body,
          phone_number: struct.phone_number
        }
        case get_request(@action, data) do
          {:ok, response} ->
            {:reply, response, state}
          {:error, response} ->
            {:noreply, response}
        end
    end
  end

  @spec handle_call(any(), any(), map() | atom()) :: {:reply, list(), map()} | {:reply, list(), atom()}
  def handle_call(_term, _pid, state) do
    {:reply, [], state}
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
    Connector.Timeout.new(250, backoff: 1.25, backoff_max: 1_250, random: 0.1)
    |> Connector.Timeout.send_after(self(), :found)
    case get_request(@action, state) do
      {:ok, response} ->
        {:noreply, response}
      {:error, response} ->
        {:noreply, response}
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

  @spec handle_info(any(), map()) :: {:noreply, map()} | {:noreply, atom()}
  def handle_info(_msg, state) do
    IO.puts("Received arguments: #{inspect(state)}")
    {:noreply, state}
  end

  @spec terminate(any(), any()) :: atom()
  def terminate(_reason, _state), do: :ok

  defp schedule_work do
    Process.send_after(self(), :more_init, 3_000)
  end

  @spec check_id(String.t()) :: Message.t() | nil
  defp check_id(id), do: Repo.get(Message, id)

  @spec get_request(String.t(), map()) :: {:ok, map()} | {:error, atom()}
  defp get_request(action, data) do
    body = URI.encode_query(%{
      "status" => "send",
      "sms" => data.phone_number,
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
      sms: struct["sms"],
      status: struct["status"],
      text: struct["text"]
    }
  end

  @spec timer(non_neg_integer()) :: non_neg_integer()
  defp timer(num) do
    Enum.random(num..9_000)
    |> Process.sleep()
  end
end
