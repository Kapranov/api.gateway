defmodule Connector.Kyivstar do
  @moduledoc """
  Kyivstar REST API wrapper in Elixir
  """

  alias Connector.Utils

  @message_body "You will beat yourself up if you sell this unit!  I sold mine for a Tak and hate every minute of it."
  @num 999..9_999
  @phone_number "+380991111111"
  @timeout 99_999

  use Tesla
  plug Tesla.Middleware.BaseUrl, "http://httpbin.org/"
  plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Timeout, timeout: @timeout

  @doc """
  Virtual Kyivstar REST API

  ## Example

      iex> Connector.Kyivstar.send(%{phone_number: "+380991111111", message_body: "Hello World!"})
      {:ok, %{"status" => "send"}}
      iex> Connector.Kyivstar.send(%{phone_number: "+380991111111", message_body: "Hello World!"})
      {:ok, %{"status" => "error"}}

  """
  @spec send(%{phone_number: String.t(), message_body: String.t()}) :: {:ok, %{String.t() => String.t()}}
  def send(args \\ %{phone_number: @phone_number, message_body: @message_body}) do
    path = "post"
    case Utils.random_state() do
      :ok ->
        data = %{"status" => "send", "sms" => args.phone_number, "text" => args.message_body}
        {:ok, %Tesla.Env{:body => body}} = post(path, data)
        :timer.sleep(Utils.random_timer(@num))
        {:ok, Utils.transfer(body["data"])}
      :error ->
        data = %{"status" => "error"}
        {:ok, %Tesla.Env{:body => body}} = post(path, data)
        Process.sleep(Utils.random_timer(@num))
        {:ok, Utils.transfer(body["data"])}
    end
  end
end
