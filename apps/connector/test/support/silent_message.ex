defmodule SilentMessage do
  @moduledoc """
  TestBrod call the message handler with the restructured Kafka message.
  """

  @connector :kafka

  def handle_message(_message), do: :ok

  def handle_messages(messages) do
    for %{key: key, value: value} = message <- messages do
      case is_list(:ets.info(@connector)) do
        true ->
          try do
            :ets.insert(@connector, {key, value})
          rescue
            ArgumentError ->
              IO.inspect message
          end
        false ->
          :ets.new(@connector, [:set, :public, :named_table])
          :ets.insert(@connector, {key, value})
      end
      IO.inspect message
    end
    :ok
  end
end
