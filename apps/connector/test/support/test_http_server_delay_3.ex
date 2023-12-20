defmodule Connector.TestHTTPServerDelay3 do
  @moduledoc """
  TestHTTP web server for api calls.
  """

  use GenServer

  alias Core.{Logs.SmsLog, Repo}
  alias Ecto.Multi

  @action [post: "post"]
  @external_api Application.compile_env(:connector, :external_api)
  @headers %{"content-type" => "application/json"}
  @name __MODULE__
  @options []
  @timeout 1_000

  @doc """
  Server HTTP Request & Response Service.
  """
  @spec start_link(map()) :: {atom(), pid} | atom()
  def start_link(args) do
      GenServer.start_link(@name, args, name: @name)
    catch
      :exit, _reason -> :error
  end

  @spec get_status(String.t(), integer(), String.t(), String.t(), String.t()) :: map() | atom()
  def get_status(message_id, priority, status_one, status_two, status_three) do
    try do
      GenServer.call(@name, :timer_one)
    catch
      :exit, _reason ->
        {:ok, _} = save_logs(message_id, priority, status_one)
        try do
          GenServer.call(@name, :timer_two)
        catch
          :exit, _reason ->
            {:ok, _} = save_logs(message_id, priority, status_two)
            try do
              GenServer.call(@name, :timer_three)
            catch
              :exit, _reason ->
                {:ok, _} = save_logs(message_id, priority, status_three)
                :timeout
            end
        end
    end
  end

  @spec stop(pid) :: :ok | :error
  def stop(pid) do
      GenServer.stop(pid, :normal, @timeout)
    catch
      :exit, _reason -> :error
  end

  @spec init(map()) ::
        {atom(), map(), {:continue, atom()}}
  def init(state) do
    {:ok, state, {:continue, :external_api_post}}
  end

  @spec handle_call(atom, any(), map() | atom()) ::
        {:reply, map(), map()} |
        {:reply, map(), atom()}
  def handle_call(:timer_one, _pid, state) do
    {:reply, state, state, 10_000}
  end

  @spec handle_call(atom, any(), map() | atom()) ::
        {:reply, map(), map()} |
        {:reply, map(), atom()}
  def handle_call(:timer_two, _pid, state) do
    {:reply, state, state, 5_000}
  end

  @spec handle_call(atom, any(), map() | atom()) ::
        {:reply, map(), map()} |
        {:reply, map(), atom()}
  def handle_call(:timer_three, _pid, state) do
    {:reply, state, state, 5_000}
  end

  @spec handle_continue(atom(), map()) ::
        {:noreply, map()} |
        {:noreply, atom()}
  def handle_continue(:external_api_post, state) do
    action = Keyword.get(@action, :post)
    case post_request(action, state) do
      {:ok, response} ->
        IO.puts("Received arguments: #{inspect(state)}")
        IO.puts("Received arguments: #{inspect(response)}")
        {:noreply, response, {:continue, :external_api_get}}
      {:error, response} ->
        {:noreply, response}
    end
  end

  @spec handle_continue(atom(), map()) ::
        {:noreply, map()} |
        {:noreply, atom()}
  def handle_continue(:external_api_get, state) do
    action = Keyword.get(@action, :post)
    case get_request(action, state) do
      {:ok, response} ->
        IO.puts("Received arguments: #{inspect(response)}")
        {:noreply, response}
      {:error, response} ->
        {:noreply, response}
    end
  end

  @spec handle_info(any(), map()) :: {:noreply, map()} | {:noreply, atom()}
  def handle_info(:timeout, state) do
    {:noreply, state}
  end

  @spec terminate(any(), any()) :: atom()
  def terminate(_reason, _state), do: :ok

  @spec post_request(String.t(), map()) :: {:ok, map()} | {:error, atom()}
  defp post_request(action, data) do
    body = URI.encode_query(%{
      "id" => data.id,
      "connector" => data.connector,
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

  @spec get_request(String.t(), map()) :: {:ok, map()} | {:error, atom()}
  defp get_request(action, data) do
    body = URI.encode_query(%{
      "id" => data.id,
      "connector" => data.connector,
      "sms" => data.sms,
      "status" => "delivered",
      "text" => data.text
    })

    url = api_route(action)

    case HTTPoison.post(url, body, @headers, @options) do
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
      {:ok, %HTTPoison.Response{body: body}} ->
        state = decode(body)
        timer(7_600)
        {:ok, state}
    end
  end

  @spec api_route(String.t()) :: String.t()
  defp api_route(action), do: "#{@external_api}/#{action}"

  @spec decode(map()) :: map()
  defp decode(data) do
    struct =
      data
      |> Jason.decode!
      |> Map.get("data")
      |> URI.decode_query

    %{
      connector: struct["connector"],
      id: struct["id"],
      sms: struct["sms"],
      status: struct["status"],
      text: struct["text"]
    }
  end

  @spec timer(non_neg_integer()) :: non_neg_integer()
  defp timer(num) do
    Enum.random(num..7_900)
    |> Process.sleep()
  end

  @spec save_logs(String.t(), integer(), String.t()) ::
        {atom(), map()} |
        {atom(), []}
  defp save_logs(message_id, priority, status_id) do
    changeset = SmsLog.changeset(%SmsLog{}, %{
      priority: priority,
      messages: message_id,
      statuses: status_id
    })
    Multi.new
    |> Multi.insert(:sms_logs, changeset)
    |> Multi.inspect()
    |> Repo.transaction()
    |> case do
      {:ok, %{sms_logs: sms_log}} ->
        {:ok, sms_log}
      {:error, _model, _changeset, _completed} ->
        {:ok, []}
    end
  end
end
