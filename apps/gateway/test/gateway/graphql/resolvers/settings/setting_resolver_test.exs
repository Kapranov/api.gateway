defmodule Gateway.GraphQL.Resolvers.Settings.SettingResolverTest do
  use Gateway.ConnCase

  alias Gateway.GraphQL.Resolvers.{
    Home.IndexPageResolver,
    Settings.SettingResolver
  }

  alias Faker.Lorem

  setup_all do
    {:ok, token} = IndexPageResolver.token(nil, nil, nil)
    context = %{context: %{token: token}}
    context
  end

  describe "#unauthorized" do
    test "returns Setting with empty list" do
      {:ok, []} = SettingResolver.list(nil, nil, nil)
    end

    test "returns Setting with data" do
      insert(:setting)
      {:ok, data} = SettingResolver.list(nil, nil, nil)
      assert data == []
    end

    test "returns specific Setting by id" do
      struct = insert(:setting)
      {:ok, []} = SettingResolver.show(nil, %{id: struct.id}, nil)
    end

    test "returns empty list when Setting does not exist" do
      id = FlakeId.get()
      {:ok, []} = SettingResolver.show(nil, %{id: id}, nil)
    end

    test "creates Setting" do
      args = %{param: "calc_priority", value: :priority}
      {:ok, []} = SettingResolver.create(nil, args, nil)
    end

    test "returns empty list when missing params" do
      args = %{param: nil, value: nil}
      {:ok, []} = SettingResolver.create(nil, args, nil)
    end

    test "returns errors when unique_constraint param has been taken" do
      insert(:setting)
      args = %{param: "calc_priority", value: :priority}
      {:ok, []} = SettingResolver.create(nil, args, nil)
    end

    test "create Setting with validations length min 5 for param" do
      args = %{param: Lorem.characters(4), value: :priority}
      {:ok, []} = SettingResolver.create(nil, args, nil)
    end

    test "create Setting with validations length max 100 for param" do
      args = %{param: Lorem.characters(101), value: :priority}
      {:ok, []} = SettingResolver.create(nil, args, nil)
    end

    test "create Setting enum for value" do
      args = %{param: "calc_priority", value: :hello}
      {:ok, []} = SettingResolver.create(nil, args, nil)
    end

    test "update specific Setting by id" do
      struct = insert(:setting)
      params = %{param: "calc_priority", value: :priceext_priceint}
      args = %{id: struct.id, setting: params}
      {:ok, []} = SettingResolver.update(nil, args, nil)
    end

    test "nothing change for missing params" do
      struct = insert(:setting)
      params = %{}
      args = %{id: struct.id, setting: params}
      {:ok, []} = SettingResolver.update(nil, args, nil)
    end

    test "returns empty list for missing params" do
      struct = insert(:setting)
      params = %{param: nil, value: nil}
      args = %{id: struct.id, setting: params}
      {:ok, []} = SettingResolver.update(nil, args, nil)
    end

    test "returns empty list when unique_constraint param has been taken" do
      insert(:setting)
      struct = insert(:setting, param: "some text#2")
      params = %{param: "some text", value: :priority}
      args = %{id: struct.id, setting: params}
      {:ok, []} = SettingResolver.create(nil, args, nil)
    end

    test "returns empty list with validations length min 5 for param" do
      struct = insert(:setting)
      params = %{param: Lorem.characters(4), value: :priceext_priceint}
      args = %{id: struct.id, setting: params}
      {:ok, []} = SettingResolver.update(nil, args, nil)
    end

    test "returns empty list with validations length max 100 for param" do
      struct = insert(:setting)
      params = %{param: Lorem.characters(101), value: :priceext_priceint}
      args = %{id: struct.id, setting: params}
      {:ok, []} = SettingResolver.update(nil, args, nil)
    end

    test "returns empty list enum for value" do
      struct = insert(:setting)
      params = %{param: "updated some text", value: :hello}
      args = %{id: struct.id, setting: params}
      {:ok, []} = SettingResolver.update(nil, args, nil)
    end
  end

  describe "#list" do
    test "returns Setting with empty list", context do
      {:ok, []} = SettingResolver.list(nil, nil, context)
    end

    test "returns Setting with data", context do
      insert(:setting)
      {:ok, data} = SettingResolver.list(nil, nil, context)
      assert length(data) == 1
    end
  end

  describe "#show" do
    test "returns specific Setting by id", context do
      struct = insert(:setting)
      {:ok, found} = SettingResolver.show(nil, %{id: struct.id}, context)
      assert found.id          == struct.id
      assert found.param       == struct.param
      assert found.value       == struct.value
      assert found.inserted_at == struct.inserted_at
      assert found.updated_at  == struct.updated_at
      assert found.anonymized  == false
    end

    test "returns empty list when Setting does not exist", context do
      id = FlakeId.get()
      {:ok, []} = SettingResolver.show(nil, %{id: id}, context)
    end
  end

  describe "#create" do
    test "creates Setting", context do
      args = %{param: "calc_priority", value: :priority}
      {:ok, created} = SettingResolver.create(nil, args, context)
      assert created.param      == args.param
      assert created.value      == :priority
      assert created.anonymized == false
    end

    test "returns empty list when missing params", context do
      args = %{param: nil, value: nil}
      {:ok, []} = SettingResolver.create(nil, args, context)
    end

    test "returns errors when unique_constraint param has been taken", context do
      insert(:setting)
      args = %{param: "calc_priority", value: :priority}
      {:ok, []} = SettingResolver.create(nil, args, context)
    end

    test "create Setting with validations length min 5 for param", context do
      args = %{param: Lorem.characters(4), value: :priority}
      {:ok, []} = SettingResolver.create(nil, args, context)
    end

    test "create Setting with validations length max 100 for param", context do
      args = %{param: Lorem.characters(101), value: :priority}
      {:ok, []} = SettingResolver.create(nil, args, context)
    end

    test "create Setting enum for value", context do
      args = %{param: "calc_priority", value: :hello}
      {:ok, []} = SettingResolver.create(nil, args, context)
    end
  end

  describe "#update" do
    test "update specific Setting by id", context do
      struct = insert(:setting)
      params = %{param: "calc_priority", value: :priceext_priceint}
      args = %{id: struct.id, setting: params}
      {:ok, updated} = SettingResolver.update(nil, args, context)
      assert updated.id          == struct.id
      assert updated.param       == params.param
      assert updated.value       == params.value
      assert updated.inserted_at == struct.inserted_at
      assert updated.updated_at  != struct.updated_at
      assert updated.anonymized  == false
    end

    test "nothing change for missing params", context do
      struct = insert(:setting)
      params = %{}
      args = %{id: struct.id, setting: params}
      {:ok, updated} = SettingResolver.update(nil, args, context)
      assert updated == struct
    end

    test "returns empty list for missing params", context do
      struct = insert(:setting)
      params = %{param: nil, value: nil}
      args = %{id: struct.id, setting: params}
      {:ok, []} = SettingResolver.update(nil, args, context)
    end

    test "returns empty list when unique_constraint param has been taken", context do
      insert(:setting)
      struct = insert(:setting, param: "some text#2")
      params = %{param: "some text", value: :priority}
      args = %{id: struct.id, setting: params}
      {:ok, []} = SettingResolver.create(nil, args, context)
    end

    test "returns empty list with validations length min 5 for param", context do
      struct = insert(:setting)
      params = %{param: Lorem.characters(4), value: :priceext_priceint}
      args = %{id: struct.id, setting: params}
      {:ok, []} = SettingResolver.update(nil, args, context)
    end

    test "returns empty list with validations length max 100 for param", context do
      struct = insert(:setting)
      params = %{param: Lorem.characters(101), value: :priceext_priceint}
      args = %{id: struct.id, setting: params}
      {:ok, []} = SettingResolver.update(nil, args, context)
    end

    test "returns empty list enum for value", context do
      struct = insert(:setting)
      params = %{param: "updated some text", value: :hello}
      args = %{id: struct.id, setting: params}
      {:ok, []} = SettingResolver.update(nil, args, context)
    end
  end
end
