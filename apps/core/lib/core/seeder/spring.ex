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
      status2,
      status3,
      status4,
      status5,
      status6
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
        message_expired_at: random_datetime(+16),
        phone_number: "+380984263462",
        status_changed_at: random_datetime(+10),
        status_id: status1.id
      }),
      Spring.create_message(%{
        id_external: "2",
        id_tax: 2408888881,
        id_telegram: "@telegaUser",
        message_body: "Ваш код - 7777-999-9999-10000",
        message_expired_at: random_datetime(+6),
        phone_number: "+380984263462",
        status_changed_at: random_datetime(+3),
        status_id: status2.id
      }),
      Spring.create_message(%{
        id_external: "3",
        id_tax: 2408888881,
        id_telegram: "@telegaUser",
        message_body: "Ваш код - 7777-999-9999-10001",
        message_expired_at: random_datetime(+10),
        phone_number: "+380984263462",
        status_changed_at: random_datetime(+5),
        status_id: status3.id
      }),
      Spring.create_message(%{
        id_external: "4",
        id_tax: 2408888881,
        id_telegram: "@telegaUser",
        message_body: "Ваш код - 7777-999-9999-10002",
        message_expired_at: random_datetime(+3),
        phone_number: "+380984263462",
        status_changed_at: random_datetime(+2),
        status_id: status4.id
      }),
      Spring.create_message(%{
        id_external: "5",
        id_tax: 2408888881,
        id_telegram: "@telegaUser",
        message_body: "Ваш код - 7777-999-9999-10003",
        message_expired_at: random_datetime(+8),
        phone_number: "+380984263462",
        status_changed_at: random_datetime(+4),
        status_id: status5.id
      }),
      Spring.create_message(%{
        id_external: "6",
        id_tax: 2408888881,
        id_telegram: "@telegaUser",
        message_body: "Код рецепту - 34567",
        message_expired_at: random_datetime(+2),
        phone_number: "+380984263462",
        status_changed_at: random_datetime(+1),
        status_id: status6.id
      }),
      Spring.create_message(%{
        id_external: "7",
        id_tax: 2408888881,
        id_telegram: "@telegaUser",
        message_body: "Код рецепту - 34568",
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

  @spec random_datetime(neg_integer() | pos_integer()) :: DateTime.t()
  defp random_datetime(num) do
    timestamp =
      DateTime.utc_now
      |> DateTime.add(num, :day)

    timestamp
  end
end
