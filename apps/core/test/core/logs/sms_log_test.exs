defmodule Core.Logs.SmsLogTest do
  use Core.DataCase

  describe "Status" do
    alias Core.{
      Logs,
      Logs.SmsLog
    }

    @valid_attrs %{priority: 1}
    @invalid_attrs %{priority: nil}

    test "create_sms_log/1" do
      operator = insert(:operator)
      message = insert(:message)
      attrs = Map.merge(@valid_attrs, %{
        operator_id: operator.id,
        message_id: message.id,
        status_id: message.status.id})
      assert {:ok, %SmsLog{} = created} = Logs.create_sms_log(attrs)
      assert created.priority == @valid_attrs.priority
    end

    test "create_sms_log/1 with validations integer max 99 for priority" do
      operator = insert(:operator)
      message = insert(:message)
      attrs = Map.merge(@valid_attrs, %{
        message_id: message.id,
        operator_id: operator.id,
        priority: Faker.random_between(100, 101),
        status_id: message.status.id
      })
      assert {:error, %Ecto.Changeset{}} = Logs.create_sms_log(attrs)
    end

    test "create_sms_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logs.create_sms_log(@invalid_attrs)
    end

    test "get_sms_log/1" do
      message = insert(:message)
      sms_log = insert(:sms_log, %{
        operators: [insert(:operator)],
        messages: [message],
        statuses: [message.status]
      })
      struct = Logs.get_sms_log(sms_log.id)
      assert struct.id       == sms_log.id
      assert struct.priority == sms_log.priority
    end

    test "get_sms_log/1 with invalid id returns error changeset" do
      sms_log_id = FlakeId.get()
      assert {:error, %Ecto.Changeset{}} = Logs.get_sms_log(sms_log_id)
    end
  end
end
