defmodule Connector.Intertelecom do
  @moduledoc """
  Intertelecom REST API wrapper in Elixir
  """

  use Tesla
  plug Tesla.Middleware.BaseUrl, "http://httpbin.org/"
  plug Tesla.Middleware.Headers, [{"content-type", "application/json"}]
  plug Tesla.Middleware.JSON

  @message_body "You will beat yourself up if you sell this unit!  I sold mine for a Tak and hate every minute of it."
  @phone_number "+380991111111"

  def send(args \\ %{phone_number: @phone_number, message_body: @message_body}) do
    path = "post"
    case random_state() do
      :ok ->
        data = %{"status" => "send", "sms" => args.phone_number, "text" => args.message_body}
        {:ok, %Tesla.Env{:body => body}} = post(path, data)
        {:ok, transfer(body["data"])}
      :error ->
        data = %{"status" => "error"}
        {:ok, %Tesla.Env{:body => body}} = post(path, data)
        {:ok, transfer(body["data"])}
    end
  end

  @spec random_state() :: atom()
  defp random_state do
    value = ~W(ok error)a
    Enum.random(value)
  end

  @spec transfer(map()) :: map()
  defp transfer(data) do
    data
    |> Jason.decode!
    |> Map.delete("sms")
    |> Map.delete("text")
  end
end
