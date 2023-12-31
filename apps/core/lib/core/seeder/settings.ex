defmodule Core.Seeder.Settings do
  @moduledoc """
  Seeds for `Core.Settings` context.
  """

  alias Core.{
    Settings,
    Settings.Setting,
    Repo
  }

  alias Ecto.Adapters.SQL

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    SQL.query!(Repo, "TRUNCATE settings CASCADE;")
    IO.puts("Deleting old data in Model's Settings\n")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_setting()
    IO.puts("Insereted data in Model's Settings\n")
  end

  @spec seed_setting() :: nil | Ecto.Schema.t()
  defp seed_setting do
    case Repo.aggregate(Setting, :count, :id) > 0 do
      true -> nil
      false -> insert_setting()
    end
  end

  @spec insert_setting() :: {:ok, any()} | {:error, any()}
  defp insert_setting do
    [
      Settings.create_setting(%{
        param: random_param(),
        value: random_value()
      })
    ]
  end

  @spec random_param :: [String.t()]
  defp random_param do
    names = ["calc_priority"]

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
  defp random_value do
    names = [
      "price",
      "priceext_priceint",
      "priority"
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
