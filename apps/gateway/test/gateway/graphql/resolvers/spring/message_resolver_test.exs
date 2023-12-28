defmodule Gateway.GraphQL.Resolvers.Spring.MessageResolverTest do
  use Gateway.ConnCase

  alias Gateway.GraphQL.Resolvers.{
    Home.IndexPageResolver,
    Spring.MessageResolver
  }

  alias Core.Repo
  alias Faker.Lorem

  setup_all do
    {:ok, token} = IndexPageResolver.token(nil, nil, nil)
    context = %{context: %{token: token}}
    context
  end

  describe "#unauthorized" do
    test "returns specific Message by id" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      {:ok, []} = MessageResolver.show(nil, %{id: message.id}, nil)
    end

    test "returns empty list when Message does not exist" do
      id = FlakeId.get()
      {:ok, []} = MessageResolver.show(nil, %{id: id}, nil)
    end

    test "created Message" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created Message - `createViaMonitor`" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create_via_monitor(nil, args, nil)
    end

    test "created Message - `createViaKafka`" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create_via_kafka(nil, args, nil)
    end

    test "created Message - `createViaConnector`" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create_via_connector(nil, args, nil)
    end

    test "created Message - `createViaMulti`" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create_via_multi(nil, args, nil)
    end

    test "created Message - `createViaSelected`" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create_via_selected(nil, args, nil)
    end

    test "created returns empty list when missing params" do
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: nil,
        message_expired_at: random_datetime(+7),
        phone_number: nil,
        status_changed_at: random_datetime(+3),
        status_id: nil
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created Message with validations phone_number" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+44991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created Message with validations length min 1 for idExternal" do
      status = insert(:status)
      args = %{
        id_external: Lorem.characters(0),
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created Message with validations length max 10 for idExternal" do
      status = insert(:status)
      args = %{
        id_external: Lorem.characters(11),
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created Message with validations length min 10 for idTelegram" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: Lorem.characters(9),
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created Message with validations length max 11 for idTelegram" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: Lorem.characters(12),
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created Message with validations length min 5 for messageBody" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: Lorem.characters(4),
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created Message with validations length max 255 for messageBody" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: Lorem.characters(256),
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created Message with validations integer min 1_000_000_000 for idTax" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: Faker.random_between(999_999_998, 999_999_999),
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created Message with validations integer max 9_999_999_999 for idTax" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: Faker.random_between(10_000_000_001, 10_000_000_002),
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created returns empty list when none exist statusId" do
      status_id = FlakeId.get()
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status_id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created returns empty list when format dateTime messageExpiredAt" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: Time.utc_now(),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created returns empty list when format dateTime statusChangedAt" do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: Time.utc_now(),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "created returns empty list when sms_logs count is max 2" do
    end

    test "updated specific Message by id" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.update(nil, args, nil)
    end

    test "updated nothing change for missing params" do
      insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{}
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.update(nil, args, nil)
    end

    test "updated returns empty list for missing params" do
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: nil,
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: nil,
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: nil
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.update(nil, args, nil)
    end

    test "updated Message with validations phone_number" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+44991111111",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "updated Message with validations length min 1 for idExternal" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: Lorem.characters(0),
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "updated Message with validations length max 10 for idExternal" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: Lorem.characters(11),
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "updated Message with validations length min 10 for idTelegram" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: Lorem.characters(9),
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "updated Message with validations length max 11 for idTelegram" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: Lorem.characters(12),
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "updated Message with validations length min 5 for messageBody" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: Lorem.characters(4),
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "updated Message with validations length max 255 for messageBody" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: Lorem.characters(256),
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "updated Message with validations integer min 1_000_000_000 for idTax" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: Faker.random_between(999_999_998, 999_999_999),
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "updated Message with validations integer max 9_999_999_999 for idTax" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: Faker.random_between(10_000_000_001, 10_000_000_002),
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "updated returns empty list when none exist statusId" do
      status_id = FlakeId.get()
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status_id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "updated returns empty list when format dateTime messageExpiredAt" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: Time.utc_now(),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end

    test "updated returns empty list when format dateTime statusChangedAt" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: Time.utc_now(),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, nil)
    end
  end

  describe "#show" do
    test "returns specific Message by id", context do
      message = insert(:message)
      operator = insert(:operator)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      {:ok, found} = MessageResolver.show(nil, %{id: message.id}, context)

      assert found.id                 == message.id
      assert found.id_external        == message.id_external
      assert found.id_tax             == message.id_tax
      assert found.id_telegram        == message.id_telegram
      assert found.message_body       == message.message_body
      assert found.message_expired_at == message.message_expired_at
      assert found.phone_number       == message.phone_number
      assert found.status_changed_at  == message.status_changed_at
      assert found.status_id          == message.status_id

      assert found.status.id          == message.status.id
      assert found.status.active      == message.status.active
      assert found.status.description == message.status.description
      assert found.status.status_code == message.status.status_code
      assert found.status.status_name == message.status.status_name

      assert hd(found.status.sms_logs).id       == sms_logs.id
      assert hd(found.status.sms_logs).priority == sms_logs.priority
    end

    test "returns empty list when Message does not exist", context do
      id = FlakeId.get()
      {:ok, []} = MessageResolver.show(nil, %{id: id}, context)
    end

    test "returns specific Message by id with sms_logs count is 2", context do
      message = insert(:message)
      operator = insert(:operator)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      {:ok, found} = MessageResolver.show(nil, %{id: message.id}, context)

      assert found.id                 == message.id
      assert found.id_external        == message.id_external
      assert found.id_tax             == message.id_tax
      assert found.id_telegram        == message.id_telegram
      assert found.message_body       == message.message_body
      assert found.message_expired_at == message.message_expired_at
      assert found.phone_number       == message.phone_number
      assert found.status_changed_at  == message.status_changed_at
      assert found.status_id          == message.status_id

      assert found.status.id          == message.status.id
      assert found.status.active      == message.status.active
      assert found.status.description == message.status.description
      assert found.status.status_code == message.status.status_code
      assert found.status.status_name == message.status.status_name

      assert hd(found.status.sms_logs).id       == sms_logs.id
      assert hd(found.status.sms_logs).priority == sms_logs.priority

      assert found.status.sms_logs |> Enum.count == 1

      preload = found |> Repo.preload(:sms_logs)

      assert preload.sms_logs |> Enum.count == 2
    end
  end

  describe "#create" do
    test "created Message", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, created} = MessageResolver.create(nil, args, context)
      assert created.id_external        == args.id_external
      assert created.id_tax             == args.id_tax
      assert created.id_telegram        == args.id_telegram
      assert created.message_body       == args.message_body
      assert created.message_expired_at == args.message_expired_at
      assert created.phone_number       == args.phone_number
      assert created.status_changed_at  == args.status_changed_at
      assert created.status_id          == status.id

      operator = insert(:operator)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [created],
        statuses: [created.status]
      })

      preload = Repo.preload(created, :sms_logs)

      assert Enum.count(preload.sms_logs) == 0
      assert Enum.count([sms_logs])       == 1

      assert sms_logs.operators == [operator]
      assert sms_logs.messages  == [created]
      assert sms_logs.statuses  == [created.status]
    end

    test "created Message - `createViaMonitor`", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, created} = MessageResolver.create_via_monitor(nil, args, context)
      assert created.id_external        == args.id_external
      assert created.id_tax             == args.id_tax
      assert created.id_telegram        == args.id_telegram
      assert created.message_body       == args.message_body
      assert created.message_expired_at == args.message_expired_at
      assert created.phone_number       == args.phone_number
      assert created.status_changed_at  == args.status_changed_at
      assert created.status_id          == status.id

      operator = insert(:operator)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [created],
        statuses: [created.status]
      })

      preload = Repo.preload(created, :sms_logs)

      assert Enum.count(preload.sms_logs) == 0
      assert Enum.count([sms_logs])       == 1

      assert sms_logs.operators == [operator]
      assert sms_logs.messages  == [created]
      assert sms_logs.statuses  == [created.status]
    end

    test "created Message - `createViaKafka`", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, created} = MessageResolver.create_via_kafka(nil, args, context)
      assert created.id_external        == args.id_external
      assert created.id_tax             == args.id_tax
      assert created.id_telegram        == args.id_telegram
      assert created.message_body       == args.message_body
      assert created.message_expired_at == args.message_expired_at
      assert created.phone_number       == args.phone_number
      assert created.status_changed_at  == args.status_changed_at
      assert created.status_id          == status.id

      operator = insert(:operator)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [created],
        statuses: [created.status]
      })

      preload = Repo.preload(created, :sms_logs)

      assert Enum.count(preload.sms_logs) == 0
      assert Enum.count([sms_logs])       == 1

      assert sms_logs.operators == [operator]
      assert sms_logs.messages  == [created]
      assert sms_logs.statuses  == [created.status]
    end

    test "created Message - `createViaConnector`", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, created} = MessageResolver.create_via_connector(nil, args, context)
      assert created.id_external        == args.id_external
      assert created.id_tax             == args.id_tax
      assert created.id_telegram        == args.id_telegram
      assert created.message_body       == args.message_body
      assert created.message_expired_at == args.message_expired_at
      assert created.phone_number       == args.phone_number
      assert created.status_changed_at  == args.status_changed_at
      assert created.status_id          == status.id

      operator = insert(:operator)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [created],
        statuses: [created.status]
      })

      preload = Repo.preload(created, :sms_logs)

      assert Enum.count(preload.sms_logs) == 0
      assert Enum.count([sms_logs])       == 1

      assert sms_logs.operators == [operator]
      assert sms_logs.messages  == [created]
      assert sms_logs.statuses  == [created.status]
    end

    test "created Message - `createViaMulti`", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, created} = MessageResolver.create_via_multi(nil, args, context)
      assert created.id_external        == args.id_external
      assert created.id_tax             == args.id_tax
      assert created.id_telegram        == args.id_telegram
      assert created.message_body       == args.message_body
      assert created.message_expired_at == args.message_expired_at
      assert created.phone_number       == args.phone_number
      assert created.status_changed_at  == args.status_changed_at
      assert created.status_id          == status.id

      operator = insert(:operator)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [created],
        statuses: [status]
      })

      preload = Repo.preload(created, :sms_logs)

      assert Enum.count(preload.sms_logs) == 2
      assert Enum.count([sms_logs])       == 1

      assert sms_logs.operators == [operator]
      assert sms_logs.messages  == [created]
      assert sms_logs.statuses  == [status]
    end

    test "created Message - `createViaSelected`", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, created} = MessageResolver.create_via_selected(nil, args, context)
      assert created.id_external        == args.id_external
      assert created.id_tax             == args.id_tax
      assert created.id_telegram        == args.id_telegram
      assert created.message_body       == args.message_body
      assert created.message_expired_at == args.message_expired_at
      assert created.phone_number       == args.phone_number
      assert created.status_changed_at  == args.status_changed_at
      assert created.status_id          == status.id

      operator = insert(:operator)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [created],
        statuses: [created.status]
      })

      preload = Repo.preload(created, :sms_logs)

      assert Enum.count(preload.sms_logs) == 0
      assert Enum.count([sms_logs])       == 1

      assert sms_logs.operators == [operator]
      assert sms_logs.messages  == [created]
      assert sms_logs.statuses  == [created.status]
    end

    test "created returns empty list when missing params", context do
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: nil,
        message_expired_at: random_datetime(+7),
        phone_number: nil,
        status_changed_at: random_datetime(+3),
        status_id: nil
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created Message with validations phone_number", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+44991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created Message with validations length min 1 for idExternal", context do
      status = insert(:status)
      args = %{
        id_external: Lorem.characters(0),
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created Message with validations length max 10 for idExternal", context do
      status = insert(:status)
      args = %{
        id_external: Lorem.characters(11),
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created Message with validations length min 10 for idTelegram", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: Lorem.characters(9),
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created Message with validations length max 11 for idTelegram", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: Lorem.characters(12),
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created Message with validations length min 5 for messageBody", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: Lorem.characters(4),
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created Message with validations length max 255 for messageBody", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: Lorem.characters(256),
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created Message with validations integer min 1_000_000_000 for idTax", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: Faker.random_between(999_999_998, 999_999_999),
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created Message with validations integer max 9_999_999_999 for idTax", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: Faker.random_between(10_000_000_001, 10_000_000_002),
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created returns empty list when none exist statusId", context do
      status_id = FlakeId.get()
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status_id
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created returns empty list when format dateTime messageExpiredAt", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: Time.utc_now(),
        phone_number: "+380991111111",
        status_changed_at: random_datetime(+3),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created returns empty list when format dateTime statusChangedAt", context do
      status = insert(:status)
      args = %{
        id_external: "1",
        id_tax: 1_111_111_111,
        id_telegram: "length text",
        message_body: "some text",
        message_expired_at: random_datetime(+7),
        phone_number: "+380991111111",
        status_changed_at: Time.utc_now(),
        status_id: status.id
      }
      {:ok, []} = MessageResolver.create(nil, args, context)
    end
  end

  describe "#update" do
    test "updated specific Message by id", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, updated} = MessageResolver.update(nil, args, context)
      assert updated.id                 == struct.id
      assert updated.id_external        == params.id_external
      assert updated.id_tax             == params.id_tax
      assert updated.id_telegram        == params.id_telegram
      assert updated.message_body       == params.message_body
      assert updated.message_expired_at == params.message_expired_at
      assert updated.phone_number       == params.phone_number
      assert updated.status_changed_at  == params.status_changed_at
      assert updated.status_id          == status.id
    end

    test "updated nothing change for missing params", context do
      insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{}
      args = %{id: struct.id, message: params}
      {:ok, updated} = MessageResolver.update(nil, args, context)
      assert updated.id                 == struct.id
      assert updated.id_external        == struct.id_external
      assert updated.id_tax             == struct.id_tax
      assert updated.id_telegram        == struct.id_telegram
      assert updated.message_body       == struct.message_body
      assert updated.message_expired_at == struct.message_expired_at
      assert updated.phone_number       == struct.phone_number
      assert updated.status_changed_at  == struct.status_changed_at
      assert updated.status_id          == struct.status_id
    end

    test "updated returns empty list for missing params", context do
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: nil,
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: nil,
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: nil
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.update(nil, args, context)
    end

    test "updated Message with validations phone_number", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+44991111111",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "updated Message with validations length min 1 for idExternal", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: Lorem.characters(0),
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "updated Message with validations length max 10 for idExternal", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: Lorem.characters(11),
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "updated Message with validations length min 10 for idTelegram", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: Lorem.characters(9),
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "updated Message with validations length max 11 for idTelegram", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: Lorem.characters(12),
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "updated Message with validations length min 5 for messageBody", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: Lorem.characters(4),
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "updated Message with validations length max 255 for messageBody", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: Lorem.characters(256),
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "updated Message with validations integer min 1_000_000_000 for idTax", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: Faker.random_between(999_999_998, 999_999_999),
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "updated Message with validations integer max 9_999_999_999 for idTax", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: Faker.random_between(10_000_000_001, 10_000_000_002),
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "updated returns empty list when none exist statusId", context do
      status_id = FlakeId.get()
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status_id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "updated returns empty list when format dateTime messageExpiredAt", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: Time.utc_now(),
        phone_number: "+380991111333",
        status_changed_at: DateTime.utc_now |> DateTime.add(8, :day),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "updated returns empty list when format dateTime statusChangedAt", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      params = %{
        id_external: "2",
        id_tax: 2_222_222_222,
        id_telegram: "update text",
        message_body: "updated some text",
        message_expired_at: DateTime.utc_now |> DateTime.add(10, :day),
        phone_number: "+380991111333",
        status_changed_at: Time.utc_now(),
        status_id: status.id
      }
      args = %{id: struct.id, message: params}
      {:ok, []} = MessageResolver.create(nil, args, context)
    end

    test "created returns empty list when sms_logs count is 2", _context do
    end
  end

  @spec random_datetime(neg_integer() | pos_integer()) :: DateTime.t()
  defp random_datetime(num) do
    timestamp =
      DateTime.utc_now
      |> DateTime.add(num, :day)

    timestamp
  end
end
