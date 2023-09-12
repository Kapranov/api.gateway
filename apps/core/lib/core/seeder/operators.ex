defmodule Core.Seeder.Operators do
  @moduledoc """
  Seeds for `Core.Operators` context.
  """

  alias Core.{
    Operators,
    Operators.OperatorType,
    Repo
  }

  alias Ecto.Adapters.SQL

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE operator_types CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_operator_type()
  end

  @spec seed_operator_type() :: nil | Ecto.Schema.t()
  defp seed_operator_type do
    case Repo.aggregate(OperatorType, :count, :id) > 0 do
      true -> nil
      false -> insert_operator_type()
    end
  end

  @spec insert_operator_type() :: {:ok, any()} | {:error, any()}
  defp insert_operator_type do
    [
      Operators.create_operator_type(%{
        active: random_boolean(),
        name: random_names(),
        priority: random_integers()
      })
    ]
  end

  @spec random_boolean() :: boolean()
  defp random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

  @spec random_names :: [String.t()]
  defp random_names do
    names = [
      "email",
      "gsm",
      "messager"
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

  @spec random_integers() :: integer()
  defp random_integers(n \\ 99) when is_integer(n) do
    Enum.random(1..n)
  end
end
