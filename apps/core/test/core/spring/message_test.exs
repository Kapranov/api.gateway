defmodule Core.Spring.MessageTest do
  use Core.DataCase

  describe "Status" do
    alias Core.{
      Logs,
      Repo,
      Spring,
      Spring.Message
    }

    alias Faker.Lorem
    alias EctoCommons.DateTimeValidator

    @valid_attrs %{
      id_external: "1",
      id_tax: 1_111_111_111,
      id_telegram: "length text",
      message_body: "some text",
      message_expired_at: DateTime.utc_now |> DateTime.add(7, :day),
      phone_number: "+380991111111",
      sms_logs: [],
      status_changed_at: DateTime.utc_now |> DateTime.add(3, :day)
    }

    @update_attrs %{
      id_external: "2",
      id_tax: 2_222_222_222,
      id_telegram: "update text",
      message_body: "updated some text",
      message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
      phone_number: "+380991111111",
      status_changed_at: DateTime.utc_now |> DateTime.add(8, :day)
    }

    @invalid_attrs %{
      message_body: nil,
      phone_number: nil,
      status_id: nil
    }

    test "create_message/1" do
      status = insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_id: status.id})
      assert {:ok, %Message{} = created} = Spring.create_message(attrs)
      assert created.id_external        == @valid_attrs.id_external
      assert created.id_tax             == @valid_attrs.id_tax
      assert created.id_telegram        == @valid_attrs.id_telegram
      assert created.message_body       == @valid_attrs.message_body
      assert created.message_expired_at == @valid_attrs.message_expired_at
      assert created.phone_number       == @valid_attrs.phone_number
      assert created.status_changed_at  == @valid_attrs.status_changed_at
      assert created.status_id          == status.id
    end

     test "create_message/1 with same statusId" do
      status = insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_id: status.id})
      assert {:ok, %Message{} = created_one} = Spring.create_message(attrs)
      assert created_one.id_external        == @valid_attrs.id_external
      assert created_one.id_tax             == @valid_attrs.id_tax
      assert created_one.id_telegram        == @valid_attrs.id_telegram
      assert created_one.message_body       == @valid_attrs.message_body
      assert created_one.message_expired_at == @valid_attrs.message_expired_at
      assert created_one.phone_number       == @valid_attrs.phone_number
      assert created_one.status_changed_at  == @valid_attrs.status_changed_at
      assert created_one.status_id          == status.id
      assert {:ok, %Message{} = created_two} = Spring.create_message(attrs)
      assert created_two.id_external        == @valid_attrs.id_external
      assert created_two.id_external        == @valid_attrs.id_external
      assert created_two.id_tax             == @valid_attrs.id_tax
      assert created_two.id_telegram        == @valid_attrs.id_telegram
      assert created_two.message_body       == @valid_attrs.message_body
      assert created_two.message_expired_at == @valid_attrs.message_expired_at
      assert created_two.phone_number       == @valid_attrs.phone_number
      assert created_two.status_changed_at  == @valid_attrs.status_changed_at
      assert created_two.status_id          == status.id
    end

    test "create_message/1 with phone number invalid data returns error changeset" do
      status = insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_id: status.id, phone_number: "+441111111111"})
      assert {:error, %Ecto.Changeset{}} = Spring.create_message(attrs)
    end

    test "create_message/1 with validations length min 1 for id_external" do
      status = insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_id: status.id, id_external: Lorem.characters(0)})
      assert {:error, %Ecto.Changeset{}} = Spring.create_message(attrs)
    end

    test "create_message/1 with validations length max 10 for id_external" do
      status = insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_id: status.id, id_external: Lorem.characters(11)})
      assert {:error, %Ecto.Changeset{}} = Spring.create_message(attrs)
    end

    test "create_message/1 with validations length min 10 for id_telegram" do
      status = insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_id: status.id, id_telegram: Lorem.characters(9)})
      assert {:error, %Ecto.Changeset{}} = Spring.create_message(attrs)
    end

    test "create_message/1 with validations length max 11 for id_telegram" do
      status = insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_id: status.id, id_telegram: Lorem.characters(12)})
      assert {:error, %Ecto.Changeset{}} = Spring.create_message(attrs)
    end

    test "create_message/1 with validations min integer for id_tax" do
      status = insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_id: status.id, id_tax: Faker.random_between(1_000_000, 999_999_999)})
      assert {:error, %Ecto.Changeset{}} = Spring.create_message(attrs)
    end

    test "create_message/1 with validations max integer for id_tax" do
      status = insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_id: status.id, id_tax: Faker.random_between(1_000_000, 999_999_999)})
      assert {:error, %Ecto.Changeset{}} = Spring.create_message(attrs)
    end

    test "create_message/1 with validations length min 5 for message_body" do
      status = insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_id: status.id, message_body: Lorem.characters(4)})
      assert {:error, %Ecto.Changeset{}} = Spring.create_message(attrs)
    end

    test "create_message/1 with validations length max 255 for message_body" do
      status = insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_id: status.id, message_body: Lorem.characters(256)})
      assert {:error, %Ecto.Changeset{}} = Spring.create_message(attrs)
    end

    test "create_message/1 with validations utc_datetime_usec for message_expired_at" do
      types = %{message_expired_at: :utc_datetime_usec}
      params = %{message_expired_at: ~U[1000-05-24 13:26:08Z]}
      changeset =
        Ecto.Changeset.cast({%{}, types}, params, Map.keys(types))
        |> DateTimeValidator.validate_datetime(:message_expired_at, after: :utc_now)
      assert changeset.errors == [
        message_expired_at: {
          "should be after %{after}.",
          [validation: :datetime, kind: :after]
        }
      ]
    end

    test "create_message/1 with validations utc_datetime_usec for status_changed_at" do
      types = %{status_changed_at: :utc_datetime_usec}
      params = %{status_changed_at: ~U[1000-05-24 13:26:08Z]}
      changeset =
        Ecto.Changeset.cast({%{}, types}, params, Map.keys(types))
        |> DateTimeValidator.validate_datetime(:status_changed_at, after: :utc_now)
      assert changeset.errors == [
        status_changed_at: {
          "should be after %{after}.",
          [validation: :datetime, kind: :after]
        }
      ]
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Spring.create_message(@invalid_attrs)
    end

    test "get_message/1" do
      message = insert(:message)
      struct = Spring.get_message(message.id)
      assert struct.id                 == message.id
      assert struct.id_external        == @valid_attrs.id_external
      assert struct.id_tax             == @valid_attrs.id_tax
      assert struct.id_telegram        == @valid_attrs.id_telegram
      assert struct.message_body       == @valid_attrs.message_body
      assert struct.message_expired_at == message.message_expired_at
      assert struct.phone_number       == @valid_attrs.phone_number
      assert struct.status_changed_at  == message.status_changed_at
      assert struct.status_id          == message.status_id
    end

    test "get_message/1 with invalid id returns error changeset" do
      message_id = FlakeId.get()
      assert {:error, %Ecto.Changeset{}} = Spring.get_message(message_id)
    end

    test "update_message/2" do
      message = insert(:message)
      {:ok, struct} = Spring.update_message(message, @update_attrs)
      assert struct.id                      == message.id
      assert struct.id_external        == @update_attrs.id_external
      assert struct.id_tax             == @update_attrs.id_tax
      assert struct.id_telegram        == @update_attrs.id_telegram
      assert struct.message_body       == @update_attrs.message_body
      assert struct.message_expired_at == @update_attrs.message_expired_at
      assert struct.phone_number       == @update_attrs.phone_number
      assert struct.status_changed_at  == @update_attrs.status_changed_at
      assert struct.status_id          == message.status_id
    end

    test "update_message/2 with phone number invalid data returns error changeset" do
      message = insert(:message)
      attrs = Map.merge(@update_attrs, %{phone_number: "+441111111111"})
      assert {:error, %Ecto.Changeset{}} = Spring.update_message(message, attrs)
    end

    test "update_message/2 with validations length min 1 for id_external" do
      message = insert(:message)
      attrs = Map.merge(@update_attrs, %{id_external: Lorem.characters(0)})
      assert {:error, %Ecto.Changeset{}} = Spring.update_message(message, attrs)
    end

    test "update_message/2 with validations length max 10 for id_external" do
      message = insert(:message)
      attrs = Map.merge(@update_attrs, %{id_external: Lorem.characters(11)})
      assert {:error, %Ecto.Changeset{}} = Spring.update_message(message, attrs)
    end

    test "update_message/2 with validations length min 10 for id_telegram" do
      message = insert(:message)
      attrs = Map.merge(@update_attrs, %{id_telegram: Lorem.characters(9)})
      assert {:error, %Ecto.Changeset{}} = Spring.update_message(message, attrs)
    end

    test "update_message/2 with validations length max 11 for id_telegram" do
      message = insert(:message)
      attrs = Map.merge(@update_attrs, %{id_telegram: Lorem.characters(12)})
      assert {:error, %Ecto.Changeset{}} = Spring.update_message(message, attrs)
    end

    test "update_message/2 with validations min integer for id_tax" do
      message = insert(:message)
      attrs = Map.merge(@update_attrs, %{id_tax: Faker.random_between(1_000_000, 999_999_999)})
      assert {:error, %Ecto.Changeset{}} = Spring.update_message(message, attrs)
    end

    test "update_message/2 with validations max integer for id_tax" do
      message = insert(:message)
      attrs = Map.merge(@update_attrs, %{id_tax: Faker.random_between(1_000_000, 999_999_999)})
      assert {:error, %Ecto.Changeset{}} = Spring.update_message(message, attrs)
    end

    test "update_message/2 with validations length min 5 for message_body" do
      message = insert(:message)
      attrs = Map.merge(@update_attrs, %{message_body: Lorem.characters(4)})
      assert {:error, %Ecto.Changeset{}} = Spring.update_message(message, attrs)
    end

    test "update_message/2 with validations length max 255 for message_body" do
      message = insert(:message)
      attrs = Map.merge(@update_attrs, %{message_body: Lorem.characters(256)})
      assert {:error, %Ecto.Changeset{}} = Spring.update_message(message, attrs)
    end

    test "update_message/2 with validations utc_datetime_usec for message_expired_at" do
      types = %{message_expired_at: :utc_datetime_usec}
      params = %{message_expired_at: ~U[1000-05-24 13:26:08Z]}
      changeset =
        Ecto.Changeset.cast({%{}, types}, params, Map.keys(types))
        |> DateTimeValidator.validate_datetime(:message_expired_at, after: :utc_now)
      assert changeset.errors == [
        message_expired_at: {
          "should be after %{after}.",
          [validation: :datetime, kind: :after]
        }
      ]
    end

    test "update_message/1 with validations utc_datetime_usec for status_changed_at" do
      types = %{status_changed_at: :utc_datetime_usec}
      params = %{status_changed_at: ~U[1000-05-24 13:26:08Z]}
      changeset =
        Ecto.Changeset.cast({%{}, types}, params, Map.keys(types))
        |> DateTimeValidator.validate_datetime(:status_changed_at, after: :utc_now)
      assert changeset.errors == [
        status_changed_at: {
          "should be after %{after}.",
          [validation: :datetime, kind: :after]
        }
      ]
    end

    test "update_message/2 with invalid struct returns error changeset" do
      message = %Message{}
      assert {:error, %Ecto.Changeset{}} = Spring.update_message(message, %{})
    end

    test "for belongs_to Status" do
      status = insert(:status)
      message_params = build(:message, status_id: status.id)

      Repo.delete!(status)

      changeset = Message.changeset(%Message{}, Map.from_struct(message_params))

      assert {:error, changeset} = Repo.insert(changeset)
      assert changeset.errors[:status] == {
        "does not exist", [
          {:constraint, :assoc},
          {:constraint_name, "messages_status_id_fkey"}
        ]
      }
    end

    test "for many_to_many SmsLogs" do
      message = insert(:message)
      operator = insert(:operator)
      sms_log = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      struct = Logs.get_sms_log(sms_log.id)
      assert  List.first(struct.statuses) |> Map.get(:id) == message.status.id
      assert  List.first(struct.messages) |> Map.get(:id) == message.id
      assert List.first(struct.operators) |> Map.get(:id) == operator.id
    end
  end
end
