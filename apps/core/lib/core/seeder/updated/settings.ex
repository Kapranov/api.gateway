defmodule Core.Seeder.Updated.Settings do
  @moduledoc """
  An update are seeds whole settings.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_setting()
    IO.puts("Updated data on model's Settings\n")
  end

  @spec update_setting() :: Ecto.Schema.t()
  defp update_setting do
    :ok
  end

  @spec random_param :: [String.t()]
  def random_param do
    names = [
      "xxxxxxxxxx",
      "yyyyyyyyyy",
      "zzzzzzzzzz"
    ]

    numbers = 1..1
    number = Enum.random(numbers)
    [result] =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end

  @spec random_value :: [String.t()]
  def random_value do
    names = [
      "value #1",
      "value #2",
      "value #3"
    ]

    numbers = 1..1
    number = Enum.random(numbers)
    [result] =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end
end
