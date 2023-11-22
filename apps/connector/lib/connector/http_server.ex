defmodule Connector.HTTPServer do
  @moduledoc """
  Http web server for api calls.
  """

  use GenServer

  @action [post: "post"]
  @headers %{"content-type" => "application/json"}
  @name __MODULE__
  @options []
  @timeout 1_000

  defstruct [:id, :connector, :sms, :status, :text]

  @doc """
  Client HTTP Request & Response Service.

  ## Example.

      iex> args = %{connector: "vodafone", id: FlakeId.get, phone_number: "+380991111111", message_body: "Aloha!"}
      iex> {:ok, pid} = Connector.HTTPServer.start_link(args)
      {:ok, pid}
      Received arguments: %{id: "Ac4B2O2hMTwoBGc7vc", connector: "vodafone", phone_number: "+380991111111", message_body: "Aloha!"}
      Received arguments: %{id: "Ac4B2O2hMTwoBGc7vc", status: "send", text: "Aloha!", connector: "vodafone", sms: "+380991111111"}
      Received arguments: %{id: "Ac4B2O2hMTwoBGc7vc", status: "delivered", text: "Aloha!", connector: "vodafone", sms: "+380991111111"}
      iex> :sys.get_state(pid)
      %{id: "Ac49dpJdkaGO4kKHb6", status: "delivered", text: "Aloha!", connector: "vodafone", sms: "+380997170609"}
      iex> Connector.HTTPServer.get_status
      %{id: "Ac49dpJdkaGO4kKHb6", status: "delivered", text: "Aloha!", connector: "vodafone", sms: "+380991111111"}
      iex> Connector.HTTPServer.stop(pid)
      :ok

      iex> args = %{connector: "vodafone", id: FlakeId.get, phone_number: "+380991111111", message_body: "Aloha!"}
      iex> {:ok, pid} = Connector.HTTPServer.start_link(args)
      {:ok, pid}
      Received arguments: %{id: "Ac4BAqSjeT8A2A8ZBg", connector: "vodafone", phone_number: "+380991111111", message_body: "Aloha!"}
      Received arguments: %{id: "Ac4BAqSjeT8A2A8ZBg", status: "send", text: "Aloha!", connector: "vodafone", sms: "+380991111111"}
      iex> Connector.HTTPServer.get_status
      :timeout
      Received arguments: %{id: "Ac4BAqSjeT8A2A8ZBg", status: "delivered", text: "Aloha!", connector: "vodafone", sms: "+380991111111"}
      iex> Connector.HTTPServer.stop(pid)
      :ok

  """
  @spec start_link(map()) :: {atom(), pid} | atom()
  def start_link(args) do
      GenServer.start_link(@name, args, name: @name)
    catch
      :exit, _reason -> :error
  end

  @spec get_status() :: map() | atom()
  def get_status do
    try do
      GenServer.call(@name, :timer_one)
    catch
      :exit, _reason ->
        try do
          GenServer.call(@name, :timer_two)
        catch
          :exit, _reason ->
            try do
              GenServer.call(@name, :timer_three)
            catch
              :exit, _reason ->
                :timeout
            end
        end
    end
        catch
          :exit, _reason ->
            GenServer.call(@name, :timer_three)
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
      connector: struct["connector"],
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
end
