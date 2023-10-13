defmodule Gateway.GraphQL.Resolvers.Logs.SmsLogResolverTest do
  use Gateway.ConnCase

  alias Gateway.GraphQL.Resolvers.{
    Home.IndexPageResolver,
    Logs.SmsLogResolver
  }

  setup_all do
    {:ok, token} = IndexPageResolver.token(nil, nil, nil)
    context = %{context: %{token: token}}
    context
  end

  describe "#unauthorized" do
    test "returns specific SmsLogs by id" do
      message = insert(:message)
      sms_log = insert(:sms_log, %{
        operators: [insert(:operator)],
        messages: [message],
        statuses: [message.status]
      })
      {:ok, []} = SmsLogResolver.show(nil, %{id: sms_log.id}, nil)
    end

    test "returns empty list when SmsLogs does not exist" do
      id = FlakeId.get()
      {:ok, []} = SmsLogResolver.show(nil, %{id: id}, nil)
    end

    test "returns empty list when SmsLogs is null" do
      {:ok, []} = SmsLogResolver.show(nil, nil, nil)
    end

    test "for many_to_many Messages, Operators, Statuses" do
      message = insert(:message)
      operator = insert(:operator)
      sms_log = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      {:ok, []} = SmsLogResolver.show(nil, %{id: sms_log.id}, nil)
    end

    test "creates Status" do
      attrs = %{priority: 1}
      operator = insert(:operator)
      message = insert(:message)
      args = Map.merge(attrs, %{
        operator_id: operator.id,
        message_id: message.id,
        status_id: message.status.id})
      {:ok, []} = SmsLogResolver.create(nil, args, nil)
    end

    test "returns empty list when missing params" do
      attrs = %{priority: nil}
      operator = insert(:operator)
      message = insert(:message)
      args = Map.merge(attrs, %{
        operator_id: operator.id,
        message_id: message.id,
        status_id: message.status.id})
      {:ok, []} = SmsLogResolver.create(nil, args, nil)
    end

    test "returns empty list when validations integer min 1 for priority" do
      attrs = %{priority: Faker.random_between(0, 0)}
      operator = insert(:operator)
      message = insert(:message)
      args = Map.merge(attrs, %{
        operator_id: operator.id,
        message_id: message.id,
        status_id: message.status.id})
      {:ok, []} = SmsLogResolver.create(nil, args, nil)
    end

    test "returns empty list when validations integer max 99 for priority" do
      attrs = %{priority: Faker.random_between(100, 103)}
      operator = insert(:operator)
      message = insert(:message)
      args = Map.merge(attrs, %{
        operator_id: operator.id,
        message_id: message.id,
        status_id: message.status.id})
      {:ok, []} = SmsLogResolver.create(nil, args, nil)
    end
  end

  describe "#show" do
    test "returns specific SmsLogs by id", context do
      message = insert(:message)
      sms_log = insert(:sms_log, %{
        operators: [insert(:operator)],
        messages: [message],
        statuses: [message.status]
      })
      {:ok, found} = SmsLogResolver.show(nil, %{id: sms_log.id}, context)
      assert found.id       == sms_log.id
      assert found.priority == sms_log.priority
    end

    test "returns empty list when SmsLogs does not exist", context do
      id = FlakeId.get()
      {:ok, []} = SmsLogResolver.show(nil, %{id: id}, context)
    end

    test "returns empty list when SmsLogs is null", context do
      {:ok, []} = SmsLogResolver.show(nil, nil, context)
    end

    test "for many_to_many Messages, Operators, Statuses", context do
      message = insert(:message)
      operator = insert(:operator)
      sms_log = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      {:ok, found} = SmsLogResolver.show(nil, %{id: sms_log.id}, context)
      assert hd(found.statuses)  |> Map.get(:id) == message.status.id
      assert hd(found.messages)  |> Map.get(:id) == message.id
      assert hd(found.operators) |> Map.get(:id) == operator.id
    end
  end

  describe "#create" do
    test "creates Status", context do
      attrs = %{priority: 1}
      operator = insert(:operator)
      message = insert(:message)
      args = Map.merge(attrs, %{
        operator_id: operator.id,
        message_id: message.id,
        status_id: message.status.id})
      {:ok, created} = SmsLogResolver.create(nil, args, context)

      assert created.priority == args.priority
      assert hd(created.operators).id == operator.id
      assert hd(created.messages).id  == message.id
      assert hd(created.statuses).id  == message.status.id
    end

    test "returns empty list when missing params", context do
      attrs = %{priority: nil}
      operator = insert(:operator)
      message = insert(:message)
      args = Map.merge(attrs, %{
        operator_id: operator.id,
        message_id: message.id,
        status_id: message.status.id})
      {:ok, []} = SmsLogResolver.create(nil, args, context)
    end

    test "returns empty list when validations integer min 1 for priority", context do
      attrs = %{priority: Faker.random_between(0, 0)}
      operator = insert(:operator)
      message = insert(:message)
      args = Map.merge(attrs, %{
        operator_id: operator.id,
        message_id: message.id,
        status_id: message.status.id})
      {:ok, []} = SmsLogResolver.create(nil, args, context)
    end

    test "returns empty list when validations integer max 99 for priority", context do
      attrs = %{priority: Faker.random_between(100, 103)}
      operator = insert(:operator)
      message = insert(:message)
      args = Map.merge(attrs, %{
        operator_id: operator.id,
        message_id: message.id,
        status_id: message.status.id})
      {:ok, []} = SmsLogResolver.create(nil, args, context)
    end
  end
end
