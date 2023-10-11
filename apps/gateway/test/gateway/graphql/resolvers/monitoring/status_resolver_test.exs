defmodule Gateway.GraphQL.Resolvers.Monitoring.StatusResolverTest do
  use Gateway.ConnCase

  alias Gateway.GraphQL.Resolvers.{
    Home.IndexPageResolver,
    Monitoring.StatusResolver
  }

  alias Faker.Lorem

  setup_all do
    {:ok, token} = IndexPageResolver.token(nil, nil, nil)
    context = %{context: %{token: token}}
    context
  end

  describe "#unauthorized" do
    test "returns Status" do
      insert(:status)
      {:ok, []} = StatusResolver.list(nil, nil, nil)
    end

    test "returns specific Status by id" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      {:ok, []} = StatusResolver.show(nil, %{id: message.status.id}, nil)
    end

    test "returns empty list when Status does not exist" do
      id = FlakeId.get()
      {:ok, []} = StatusResolver.show(nil, %{id: id}, nil)
    end

    test "returns empty list when Status is null" do
      {:ok, []} = StatusResolver.show(nil, nil, nil)
    end

    test "creates Status" do
      args = %{active: true, description: "some text", status_code: 1, status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, nil)
    end

    test "returns empty list when missing params" do
      args = %{active: nil, status_code: nil, status_name: nil}
      {:ok, []} = StatusResolver.create(nil, args, nil)
    end

    test "returns empty list when statusCode is an uniqueIndex" do
      insert(:status, status_code: 1)
      args = %{active: true, description: "some text", status_code: 1, status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, nil)
    end

    test "returns empty list when with validations boolean for active" do
      args = %{active: nil, description: "some text", status_code: 1, status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, nil)
    end

    test "returns empty list when validations length min 3 for description" do
      args = %{active: true, description: Lorem.characters(2), status_code: 1, status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, nil)
    end

    test "returns empty list when validations length max 100 for description" do
      args = %{active: true, description: Lorem.characters(101), status_code: 1, status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, nil)
    end

    test "returns empty list when validations integer min 1 for statusCode" do
      args = %{active: true, description: "some text", status_code: Faker.random_between(0, 0), status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, nil)
    end

    test "returns empty list when validations integer max 200 for statusCode" do
      args = %{active: true, description: "some text", status_code: Faker.random_between(201, 203), status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, nil)
    end

    test "returns empty list when validations string min 3 for statusName" do
      args = %{active: true, description: "some text", status_code: 1, status_name: Lorem.characters(2)}
      {:ok, []} = StatusResolver.create(nil, args, nil)
    end

    test "returns empty list when validations string max 100 for statusName" do
      args = %{active: true, description: "some text", status_code: 1, status_name: Lorem.characters(101)}
      {:ok, []} = StatusResolver.create(nil, args, nil)
    end
  end

  describe "#list" do
    test "returns Status", context do
      insert(:status)
      {:ok, data} = StatusResolver.list(nil, nil, context)
      assert length(data) == 1
    end
  end

  describe "#show" do
    test "returns specific Status by id", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      {:ok, found} = StatusResolver.show(nil, %{id: message.status.id}, context)
      assert found.id          == message.status.id
      assert found.description == message.status.description
      assert found.status_code == message.status.status_code
      assert found.status_name == message.status.status_name
      assert found.inserted_at == message.status.inserted_at
    end

    test "returns empty list when Status does not exist", context do
      id = FlakeId.get()
      {:ok, []} = StatusResolver.show(nil, %{id: id}, context)
    end

    test "returns empty list when Status is null", context do
      {:ok, []} = StatusResolver.show(nil, nil, context)
    end
  end

  describe "#create" do
    test "creates Status", context do
      args = %{active: true, description: "some text", status_code: 1, status_name: "status #1"}
      {:ok, created} = StatusResolver.create(nil, args, context)

      message = insert(:message, status: created)
      operator = insert(:operator)
      sms_log = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      assert created.id          == message.status.id
      assert created.active      == message.status.active
      assert created.description == message.status.description
      assert created.status_code == message.status.status_code
      assert created.status_name == message.status.status_name

      [status] = sms_log.statuses

      assert status.id          == created.id
      assert status.active      == created.active
      assert status.description == created.description
      assert status.status_code == created.status_code
      assert status.status_name == created.status_name
    end

    test "returns empty list when missing params", context do
      args = %{active: nil, status_code: nil, status_name: nil}
      {:ok, []} = StatusResolver.create(nil, args, context)
    end

    test "returns empty list when statusCode is an uniqueIndex", context do
      insert(:status, status_code: 1)
      args = %{active: true, description: "some text", status_code: 1, status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, context)
    end

    test "returns empty list when with validations boolean for active", context do
      args = %{active: nil, description: "some text", status_code: 1, status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, context)
    end

    test "returns empty list when validations length min 3 for description", context do
      args = %{active: true, description: Lorem.characters(2), status_code: 1, status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, context)
    end

    test "returns empty list when validations length max 100 for description", context do
      args = %{active: true, description: Lorem.characters(101), status_code: 1, status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, context)
    end

    test "returns empty list when validations integer min 1 for statusCode", context do
      args = %{active: true, description: "some text", status_code: Faker.random_between(0, 0), status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, context)
    end

    test "returns empty list when validations integer max 200 for statusCode", context do
      args = %{active: true, description: "some text", status_code: Faker.random_between(201, 203), status_name: "status #1"}
      {:ok, []} = StatusResolver.create(nil, args, context)
    end

    test "returns empty list when validations integer min 3 for statusName", context do
      args = %{active: true, description: "some text", status_code: 1, status_name: Lorem.characters(2)}
      {:ok, []} = StatusResolver.create(nil, args, context)
    end

    test "returns empty list when validations integer max 100 for statusName", context do
      args = %{active: true, description: "some text", status_code: 1, status_name: Lorem.characters(101)}
      {:ok, []} = StatusResolver.create(nil, args, context)
    end
  end
end
