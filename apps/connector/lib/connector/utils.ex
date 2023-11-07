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

  @doc """

  ## Example.

      iex> Connector.Utils.while(fn -> 1 end, 3_000)
      :timeout
      iex> Connector.Utils.while(fn -> 1 end, 0)
      :timeout

  """
  @spec while(fun(), non_neg_integer()) :: atom()
  def while(predicate, timeout) when is_function(predicate, 0) and is_integer(timeout) do
      millisecond = System.monotonic_time(:millisecond)
      while(predicate, timeout, millisecond)
    catch
      :exit, _reason -> :timeout
  end

  @spec while(fun(), pos_integer(), neg_integer()) :: atom()
  defp while(predicate, timeout, started) when timeout > 0 do
    if predicate.() do
      now = System.monotonic_time(:millisecond)
      elapsed = now - started
      while(predicate, timeout - elapsed, now)
    else
      :ok
    end
  end

  @spec while(any(), any(), any()) :: no_return()
  defp while(_predicate, _timeout, _started), do: exit(:timeout)
end
