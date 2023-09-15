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
  alias Faker.String, as: FakerString
  alias Faker.UUID, as: FakerUUID
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
        id_external: FakerUUID.v4(),
        id_tax: FakerString.base64(10),
        id_telegram: FakerString.base64(10),
        message_body: Lorem.sentence(5..10),
        message_expired_at: FakerTime.backward(4),
        phone_number: EnUs.phone(),
        status_id: status.id
      })
    ]
  end
end
