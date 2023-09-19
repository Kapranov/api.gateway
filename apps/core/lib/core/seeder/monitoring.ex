defmodule Core.Seeder.Monitoring do
  @moduledoc """
  Seeds for `Core.Monitoring` context.
  """

  alias Core.{
    Monitoring,
    Monitoring.Status,
    Repo
  }

  alias Ecto.Adapters.SQL

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    SQL.query!(Repo, "TRUNCATE statuses CASCADE;")
    IO.puts("Deleting old data in Model's Statuses\n")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_status()
    IO.puts("Inserted data in Model's Statuses\n")
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
        active: true,
        description: "new message to send from another system",
        status_name: "new",
        status_code: 101
      }),
      Monitoring.create_status(%{
        active: true,
        description: "message in queue to be sent",
        status_name: "queue",
        status_code: 102
      }),
      Monitoring.create_status(%{
        active: true,
        description: "A message was sent to the provider and a positive response was received",
        status_name: "send",
        status_code: 103
      }),
      Monitoring.create_status(%{
        active: true,
        description: "provider status when the message is read by the user",
        status_name: "delivered",
        status_code: 104
      }),
      Monitoring.create_status(%{
        active: true,
        description: "timeToLive message expired",
        status_name: "expired",
        status_code: 105
      }),
      Monitoring.create_status(%{
        active: true,
        description: "sending error",
        status_name: "error ",
        status_code: 106
      })
    ]
  end

  @spec random_boolean() :: boolean()
  def random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

  @spec random_status_name :: [String.t()]
  def random_status_name do
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
  def random_integers(n \\ 99) when is_integer(n) do
    Enum.random(1..n)
  end
end
