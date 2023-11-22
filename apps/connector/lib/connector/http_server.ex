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
      iex> :sys.get_state(pid)
      %{id: "Ac3jGQ8zL7Ys08o8MS", status: "delivered", text: "Aloha!", connector: "vodafone", sms: "+380997170609"}
      iex> Connector.HTTPServer.stop(pid)
      :ok

  """
  @spec start_link(map()) :: {atom(), pid} | atom()
  def start_link(args) do
      GenServer.start_link(@name, args, name: @name)
    catch
      :exit, _reason -> :error
  end

  @spec stop(pid) :: :ok | :error
  def stop(pid) do
    GenServer.stop(pid, :normal, @timeout)
  end

  @spec init(map()) ::
        {atom(), map(), {:continue, atom()}}
  def init(state) do
    {:ok, state, {:continue, :external_api_post}}
  end

  @spec handle_continue(atom(), map()) ::
        {:noreply, map()} |
        {:noreply, atom()}
  def handle_continue(:external_api_post, state) do
    action = Keyword.get(@action, :post)
    case post_request(action, state) do
      {:ok, response} ->
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
        {:noreply, response}
      {:error, response} ->
        {:noreply, response}
    end
  end

  @spec terminate(any(), any()) :: atom()
  def terminate(_reason, _state), do: :ok

  @spec post_request(String.t(), map()) :: {:ok, map()} | {:error, atom()}
  def post_request(action, data) do
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
  def get_request(action, data) do
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
  def api_route(action), do: "http://httpbin.org/#{action}"

  @spec decode(map()) :: map()
  def decode(data) do
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
  def timer(num) do
    Enum.random(num..3_000)
    |> Process.sleep()
  end
end
