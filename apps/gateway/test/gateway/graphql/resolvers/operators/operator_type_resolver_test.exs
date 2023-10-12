defmodule Gateway.GraphQL.Resolvers.Operators.OperatorTypeResolverTest do
  use Gateway.ConnCase

  alias Gateway.GraphQL.Resolvers.{
    Home.IndexPageResolver,
    Operators.OperatorTypeResolver
  }

  alias Faker.Lorem

  setup_all do
    {:ok, token} = IndexPageResolver.token(nil, nil, nil)
    context = %{context: %{token: token}}
    context
  end

  describe "#unauthorized" do
    test "returns OperatorType with empty list" do
      {:ok, []} = OperatorTypeResolver.list(nil, nil, nil)
    end

    test "returns OperatorType with data" do
      insert(:operator_type)
      {:ok, []} = OperatorTypeResolver.list(nil, nil, nil)
    end

    test "returns specific OperatorType by id" do
      struct = insert(:operator_type)
      {:ok, []} = OperatorTypeResolver.show(nil, %{id: struct.id}, nil)
    end

    test "returns empty list when OperatorType does not exist" do
      id = FlakeId.get()
      {:ok, []} = OperatorTypeResolver.show(nil, %{id: id}, nil)
    end

    test "returns empty list when OperatorType is null" do
      {:ok, []} = OperatorTypeResolver.show(nil, nil, nil)
    end

    test "creates OperatorType" do
      args = %{active: true, name_type: "some text", priority: 1}
      {:ok, []} = OperatorTypeResolver.create(nil, args, nil)
    end

    test "returns empty list when missing params" do
      args = %{active: nil, name_type: nil}
      {:ok, []} = OperatorTypeResolver.create(nil, args, nil)
    end

    test "returns empty list when nameType is an uniqueIndex" do
      insert(:operator_type, name_type: "some text")
      args = %{active: true, name_type: "some text", priority: 1}
      {:ok, []} = OperatorTypeResolver.create(nil, args, nil)
    end

    test "returns empty list when with validations boolean for active" do
      args = %{active: nil, name_type: "some text", priority: 1}
      {:ok, []} = OperatorTypeResolver.create(nil, args, nil)
    end

    test "returns empty list when validations length min 3 for nameType" do
      args = %{active: true, name_type: Lorem.characters(2), priority: 1}
      {:ok, []} = OperatorTypeResolver.create(nil, args, nil)
    end

    test "returns empty list when validations length max 100 for nameType" do
      args = %{active: true, name_type: Lorem.characters(101), priority: 1}
      {:ok, []} = OperatorTypeResolver.create(nil, args, nil)
    end

    test "returns empty list when validations integer min 1 for priority" do
      args = %{active: true, name_type: "some text", priority: Faker.random_between(0, 0)}
      {:ok, []} = OperatorTypeResolver.create(nil, args, nil)
    end

    test "returns empty list when validations integer max 100 for priority" do
      args = %{active: true, name_type: "some text", priority: Faker.random_between(101, 103)}
      {:ok, []} = OperatorTypeResolver.create(nil, args, nil)
    end

    test "update specific OperatorType by id" do
      struct = insert(:operator_type)
      params = %{active: false, name_type: "updated some text", priority: 2}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.update(nil, args, nil)
    end

    test "nothing change for missing params" do
      struct = insert(:operator_type)
      params = %{}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.update(nil, args, nil)
    end

    test "returns empty list for missing params" do
      struct = insert(:operator_type)
      params = %{active: nil, name_type: nil}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.update(nil, args, nil)
    end

    test "returns empty list when unique_constraint nameType has been taken" do
      insert(:operator_type)
      struct = insert(:operator_type, name_type: "some text#2")
      params = %{active: false, name_type: "some text", priority: 2}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.create(nil, args, nil)
    end

    test "returns empty list with validations length min 3 for nameType" do
      struct = insert(:operator_type)
      params = %{active: false, name_type: Lorem.characters(2), priority: 2}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.update(nil, args, nil)
    end

    test "returns empty list with validations length max 100 for nameType" do
      struct = insert(:operator_type)
      params = %{active: false, name_type: Lorem.characters(101), priority: 2}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.update(nil, args, nil)
    end

    test "returns empty list with validations integer min 1 for priority" do
      struct = insert(:operator_type)
      params = %{active: false, name_type: "updated some text", priority: Faker.random_between(0, 0)}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.update(nil, args, nil)
    end

    test "returns empty list with validations integer max 100 for priority" do
      struct = insert(:operator_type)
      params = %{active: false, name_type: "updated some text", priority: Faker.random_between(101, 103)}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.update(nil, args, nil)
    end
  end

  describe "#list" do
    test "returns OperatorType with empty list", context do
      {:ok, []} = OperatorTypeResolver.list(nil, nil, context)
    end

    test "returns OperatorType with data", context do
      insert(:operator_type)
      {:ok, data} = OperatorTypeResolver.list(nil, nil, context)
      assert length(data) == 1
    end
  end

  describe "#show" do
    test "returns specific OperatorType by id", context do
      struct = insert(:operator_type)
      {:ok, found} = OperatorTypeResolver.show(nil, %{id: struct.id}, context)
      assert found.id        == struct.id
      assert found.active    == struct.active
      assert found.name_type == struct.name_type
      assert found.priority  == struct.priority
    end

    test "returns empty list when OperatorType does not exist", context do
      id = FlakeId.get()
      {:ok, []} = OperatorTypeResolver.show(nil, %{id: id}, context)
    end

    test "returns empty list when OperatorType is null", context do
      {:ok, []} = OperatorTypeResolver.show(nil, nil, context)
    end
  end

  describe "#create" do
    test "creates OperatorType", context do
      args = %{active: true, name_type: "some text", priority: 1}
      {:ok, created} = OperatorTypeResolver.create(nil, args, context)

      assert created.active    == args.active
      assert created.name_type == args.name_type
      assert created.priority  == args.priority
    end

    test "returns empty list when missing params", context do
      args = %{active: nil, name_type: nil}
      {:ok, []} = OperatorTypeResolver.create(nil, args, context)
    end

    test "returns empty list when nameType is an uniqueIndex", context do
      insert(:operator_type, name_type: "some text")
      args = %{active: true, name_type: "some text", priority: 1}
      {:ok, []} = OperatorTypeResolver.create(nil, args, context)
    end

    test "returns empty list when with validations boolean for active", context do
      args = %{active: nil, name_type: "some text", priority: 1}
      {:ok, []} = OperatorTypeResolver.create(nil, args, context)
    end

    test "returns empty list when validations length min 3 for nameType", context do
      args = %{active: true, name_type: Lorem.characters(2), priority: 1}
      {:ok, []} = OperatorTypeResolver.create(nil, args, context)
    end

    test "returns empty list when validations length max 100 for nameType", context do
      args = %{active: true, name_type: Lorem.characters(101), priority: 1}
      {:ok, []} = OperatorTypeResolver.create(nil, args, context)
    end

    test "returns empty list when validations integer min 1 for priority", context do
      args = %{active: true, name_type: "some text", priority: Faker.random_between(0, 0)}
      {:ok, []} = OperatorTypeResolver.create(nil, args, context)
    end

    test "returns empty list when validations integer max 100 for priority", context do
      args = %{active: true, name_type: "some text", priority: Faker.random_between(101, 103)}
      {:ok, []} = OperatorTypeResolver.create(nil, args, context)
    end
  end

  describe "#update" do
    test "update specific OperatorType by id", context do
      struct = insert(:operator_type)
      params = %{active: false, name_type: "updated some text", priority: 2}
      args = %{id: struct.id, operator_type: params}
      {:ok, updated} = OperatorTypeResolver.update(nil, args, context)
      assert updated.id          == struct.id
      assert updated.active      == params.active
      assert updated.name_type   == params.name_type
      assert updated.priority    == params.priority
      assert updated.inserted_at == struct.inserted_at
      assert updated.updated_at  != struct.updated_at
    end

    test "nothing change for missing params", context do
      struct = insert(:operator_type)
      params = %{}
      args = %{id: struct.id, operator_type: params}
      {:ok, updated} = OperatorTypeResolver.update(nil, args, context)
      assert updated.id        == struct.id
      assert updated.active    == struct.active
      assert updated.name_type == struct.name_type
      assert updated.priority  == struct.priority
    end

    test "returns empty list for missing params", context do
      struct = insert(:operator_type)
      params = %{active: nil, name_type: nil}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.update(nil, args, context)
    end

    test "returns empty list when unique_constraint nameType has been taken", context do
      insert(:operator_type)
      struct = insert(:operator_type, name_type: "some text#2")
      params = %{active: false, name_type: "some text", priority: 2}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.create(nil, args, context)
    end

    test "returns empty list with validations length min 3 for nameType", context do
      struct = insert(:operator_type)
      params = %{active: false, name_type: Lorem.characters(2), priority: 2}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.update(nil, args, context)
    end

    test "returns empty list with validations length max 100 for nameType", context do
      struct = insert(:operator_type)
      params = %{active: false, name_type: Lorem.characters(101), priority: 2}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.update(nil, args, context)
    end

    test "returns empty list with validations integer min 1 for priority", context do
      struct = insert(:operator_type)
      params = %{active: false, name_type: "updated some text", priority: Faker.random_between(0, 0)}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.update(nil, args, context)
    end

    test "returns empty list with validations integer max 100 for priority", context do
      struct = insert(:operator_type)
      params = %{active: false, name_type: "updated some text", priority: Faker.random_between(101, 103)}
      args = %{id: struct.id, operator_type: params}
      {:ok, []} = OperatorTypeResolver.update(nil, args, context)
    end
  end
end
