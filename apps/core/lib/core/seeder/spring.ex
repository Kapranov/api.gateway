defmodule Core.Seeder.Spring do
  @moduledoc """
  Seeds for `Core.Spring` context.
  """

  alias Core.{
    Monitoring.Status,
    Repo,
    Spring,
    Spring.Message
  }

  alias Ecto.Adapters.SQL

  alias Faker.DateTime, as: FakerTime
  alias Faker.{
    Lorem,
    Phone.EnUs
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE messages CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_message()
  end

  @spec seed_message() :: nil | Ecto.Schema.t()
  defp seed_message do
    case Repo.aggregate(Message, :count, :id) > 0 do
      true -> nil
      false -> insert_message()
    end
  end

  @spec insert_message() :: {:ok, any()} | {:error, any()}
  defp insert_message do
    status_ids = Enum.map(Repo.all(Status), &(&1))
    {status} = { Enum.at(status_ids, 0) }
    [
      Spring.create_message(%{
        id_external: FlakeId.get(),
        id_tax: random_uuid(10),
        id_telegram: random_uuid(10),
        message_body: Lorem.sentence(5..10),
        message_expired_at: FakerTime.backward(4),
        phone_number: EnUs.phone(),
        status_id: status.id
      })
    ]
  end

  @spec random_uuid(integer) :: String.t()
  defp random_uuid(num) do
    {uuid} =
      FlakeId.get
      |> String.split_at(num)
      |> Tuple.delete_at(1)

    uuid
  end
end
