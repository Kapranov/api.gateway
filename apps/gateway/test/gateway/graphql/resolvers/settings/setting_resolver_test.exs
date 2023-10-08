defmodule Gateway.GraphQL.Resolvers.Settings.SettingResolverTest do
  use Gateway.ConnCase

  alias Gateway.GraphQL.Resolvers.{
    Home.IndexPageResolver,
    Settings.SettingResolver
  }

  setup_all do
    {:ok, token} = IndexPageResolver.token(nil, nil, nil)
    context = %{context: %{token: token}}
    context
  end

  describe "#list" do
    test "returns Setting", context do
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
      args = %{param: "some text", value: "some text"}
      {:ok, created} = SettingResolver.create(nil, args, context)
      assert created.param      == args.param
      assert created.value      == args.value
      assert created.anonymized == false

    end

    test "returns empty list when missing params", context do
      args = %{param: nil, value: nil}
      {:ok, []} = SettingResolver.create(nil, args, context)
    end
  end

  describe "#update" do
    test "update specific Setting by id", context do
      struct = insert(:setting)
      params = %{param: "updated some text", value: "updated some text"}
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
  end
end
