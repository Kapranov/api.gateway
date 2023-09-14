defmodule Core.Seeder.Operators do
  @moduledoc """
  Seeds for `Core.Operators` context.
  """

  alias Core.{
    Operators,
    Operators.Operator,
    Operators.OperatorType,
    Repo
  }

  alias Ecto.Adapters.SQL

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE operator_types CASCADE;")
    SQL.query!(Repo, "TRUNCATE operators CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_operator_type()
    seed_operator()
  end

  @spec seed_operator_type() :: nil | Ecto.Schema.t()
  defp seed_operator_type do
    case Repo.aggregate(OperatorType, :count, :id) > 0 do
      true -> nil
      false -> insert_operator_type()
    end
  end

  @spec seed_operator() :: nil | Ecto.Schema.t()
  defp seed_operator do
    case Repo.aggregate(Operator, :count, :id) > 0 do
      true -> nil
      false -> insert_operator()
    end
  end

  @spec insert_operator_type() :: {:ok, any()} | {:error, any()}
  defp insert_operator_type do
    [
      Operators.create_operator_type(%{
        active: true,
        name_type: random_names(),
        priority: random_integers()
      })
    ]
  end

  @spec insert_operator() :: {:ok, any()} | {:error, any()}
  defp insert_operator do
    operator_type_ids = Enum.map(Repo.all(OperatorType), &(&1))
    {operator_type} = { Enum.at(operator_type_ids, 0) }
    config_nested = %{name: "Aloha", url: "Hawaii"}

    [
      Operators.create_operator(%{
        active: true,
        config: config_nested,
        phone_code: random_phone_code(),
        limit_count: random_integers(),
        name_operator: random_name_operator(),
        operator_type_id: operator_type.id,
        price_ext: random_float(),
        price_int: random_float(),
        priority: random_integers()
      })
    ]
  end

  @spec random_boolean() :: boolean()
  def random_boolean do
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

  @spec random_name_operator :: [String.t()]
  defp random_name_operator do
    names = [
      "Intertelecom",
      "Kyievstar",
      "Lifecell",
      "Vodafone"
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

  @spec random_phone_code :: [String.t()]
  defp random_phone_code do
    names = [
      "098,068,067",
      "099,066,064,061,062",
      "095,063"
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

  @spec random_float() :: float()
  def random_float do
    :rand.uniform() * 100
    |> Float.round(4)
  end
end
