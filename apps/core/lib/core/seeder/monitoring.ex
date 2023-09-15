defmodule Core.Seeder.Monitoring do
  @moduledoc """
  Seeds for `Core.Monitoring` context.
  """

  alias Core.{
    Monitoring,
    Monitoring.Status,
    Repo
  }

  alias Faker.Lorem
  alias Ecto.Adapters.SQL

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE statuses CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_status()
  end

  @spec seed_status() :: nil | Ecto.Schema.t()
  defp seed_status do
    case Repo.aggregate(Status, :count, :id) > 0 do
      true -> nil
      false -> insert_status()
    end
  end

  @spec insert_status() :: {:ok, any()} | {:error, any()}
  defp insert_status do
    [
      Monitoring.create_status(%{
        active: random_boolean(),
        description: Lorem.sentence(),
        status_name: random_status_name(),
        status_code: random_integers()
      })
    ]
  end

  @spec random_boolean() :: boolean()
  defp random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

  @spec random_status_name :: [String.t()]
  defp random_status_name do
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

  @spec random_integers() :: integer()
  defp random_integers(n \\ 99) when is_integer(n) do
    Enum.random(1..n)
  end
end
