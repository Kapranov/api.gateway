defmodule Connector.Consumer do
  @moduledoc """
  Documentation for `Consumer` by Kafka.
  """

  def handle_messages(messages) do
    for %{key: key, value: value} = message <- messages do
      IO.inspect message
      IO.puts "#{key}: #{value}"
    end
    :ok
  end
end
