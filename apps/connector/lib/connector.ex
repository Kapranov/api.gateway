defmodule Connector do
  @moduledoc """
  REST API wrapper in Elixir
  """

  @connector :kafka

  @spec handle_messages(%{key: any(), value: any()}) :: :ok
  def handle_messages(messages) do
    for %{key: key, value: value} = message <- messages do
      case is_list(:ets.info(@connector)) do
        true ->
          try do
            :ets.insert(@connector, {key, value})
          rescue
            ArgumentError ->
              if unquote(Mix.env == :dev) do
                # credo:disable-for-next-line
                IO.inspect message
              else
                message
              end
          end
        false ->
          :ets.new(@connector, [:set, :public, :named_table])
          :ets.insert(@connector, {key, value})
      end
      # credo:disable-for-next-line
      if unquote(Mix.env == :dev), do: IO.inspect message
    end
    :ok
  end
end
