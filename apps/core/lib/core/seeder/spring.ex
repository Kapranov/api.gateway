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

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    SQL.query!(Repo, "TRUNCATE messages CASCADE;")
    IO.puts("Deleting old data in Models's Messages\n")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_message()
    IO.puts("Inserted data in Models's Messages\n")
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

    { status1,
      _status2,
      _status3,
      _status4,
      _status5,
      _status6
    } = {
      Enum.at(status_ids, 0),
      Enum.at(status_ids, 1),
      Enum.at(status_ids, 2),
      Enum.at(status_ids, 3),
      Enum.at(status_ids, 4),
      Enum.at(status_ids, 5)
    }

    [
      Spring.create_message(%{
        id_external: "1",
        id_tax: 2408888881,
        id_telegram: "@telegaUser",
        message_body: "Ваш код - 7777-999-9999-9999",
        message_expired_at: FakerTime.backward(4),
        phone_number: "+380984263462",
        status_changed_at: FakerTime.backward(4),
        status_id: status1.id
      })
    ]
  end

  @spec random_uuid(integer) :: String.t()
  def random_uuid(num) do
    {uuid} =
      FlakeId.get
      |> String.split_at(num)
      |> Tuple.delete_at(1)

    uuid
  end
end
