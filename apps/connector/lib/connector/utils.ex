defmodule Connector.Utils do
  @moduledoc """
  Some function for Connector.
  """

  @spec random_state() :: atom()
  def random_state do
    value = ~W(ok error)a
    Enum.random(value)
  end

  @spec transfer(map()) :: map()
  def transfer(data) do
    data
    |> Jason.decode!
    |> Map.delete("sms")
    |> Map.delete("text")
  end

  @spec random_timer(Range.t()) :: integer()
  def random_timer(num \\ 200..999) do
    num
    |> Enum.random()
  end
end
