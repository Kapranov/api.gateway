defmodule Connector.Producer do
  @moduledoc """
  Documentation for `Producer` by Kafka.
  """

  def insert(id, phone_number, body) do
    push(id, phone_number, body)
  end

  defp push(id, phone_number, body) do
    Kaffe.Producer.produce_sync("id: #{id}", "text: #{body}, sms: #{phone_number}")
  end
end
