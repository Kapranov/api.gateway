defmodule Gateway.GraphQL.Integration.Settings.SettingIntegrationTest do
  use Gateway.ConnCase

  alias Gateway.{
    AbsintheHelpers,
    Endpoint,
    GraphQL.Resolvers.Home.IndexPageResolver,
    GraphQL.Schema
  }

  alias Faker.Lorem

  @phrase Application.compile_env(:gateway, Endpoint)[:phrase]

  setup_all do
    {:ok, token} = IndexPageResolver.token(nil, nil, nil)
    context = %{token: token}
    context
  end

  describe "#unauthorized" do
    test "returns Setting with empty list - `AbsintheHelpers`" do
      query = """
      {
        listSetting {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "setting"))

      assert json_response(res, 200)["errors"] == nil
      [] = json_response(res, 200)["data"]["listSetting"]
    end

    test "returns Setting with empty list - `Absinthe.run`" do
      query = """
      {
        listSetting {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"listSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns listSetting - `AbsintheHelpers`" do
      insert(:setting)
      query = """
      {
        listSetting {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "setting"))

      [] = json_response(res, 200)["data"]["listSetting"]
    end

    test "returns listSetting - `Absinthe.run`" do
      insert(:setting)
      query = """
      {
        listSetting {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"listSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns specific setting by id - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      {
        showSetting(id: \"#{struct.id}\") {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "setting"))

      [] = json_response(res, 200)["data"]["showSetting"]
    end

    test "returns specific setting by id - `Absinthe.run`" do
      struct = insert(:setting)
      query = """
      {
        showSetting(id: \"#{struct.id}\") {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when setting does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      {
        showSetting(id: \"#{id}\") {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "setting"))

      assert json_response(res, 200)["data"]["showSetting"] == []
    end

    test "returns empty list when setting does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      query = """
      {
        showSetting(id: \"#{id}\") {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns errors for missing params - `AbsintheHelpers`" do
      query = """
      {
        showSetting(id: nil) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "setting"))

      assert hd(json_response(res, 200)["errors"])["message"] |> String.replace("\"", "") == "Argument id has invalid value nil."
    end

    test "returns errors for missing params - `Absinthe.run`" do
      query = """
      {
        showSetting(id: nil) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: errors}} = Absinthe.run(query, Schema, context: nil)
      assert hd(errors).message |> String.replace("\"", "") == "Argument id has invalid value nil."
    end

    test "creates setting - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSetting"]
    end

    test "creates setting - `Absinthe.run`" do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: nil
          value: nil
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"]
      |> String.replace("\"", "") == "Argument param has invalid value nil."
    end

    test "returns error for missing params - `Absinthe.run`" do
      query = """
      mutation {
        createSetting(
          param: nil
          value: nil
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: nil)

      assert hd(error).message
      |> String.replace("\"", "") == "Argument param has invalid value nil."
    end

    test "returns errors when unique_constraint param has been taken - `AbsintheHelpers`" do
      insert(:setting)
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSetting"]
    end

    test "returns errors when unique_constraint param has been taken - `Absinthe.run`" do
      insert(:setting)
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "create Setting with validations length min 5 for param - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(4)}\"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSetting"]
    end

    test "create Setting with validations length min 5 for param - Absinthe.run" do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(4)}\"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "create Setting with validations length max 100 for param - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(101)}\"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSetting"]
    end

    test "create Setting with validations length max 100 for param - Absinthe.run" do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(101)}\"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "create Setting with validations length min 5 for value - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: \"#{Lorem.characters(4)}\"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSetting"]
    end

    test "create Setting with validations length min 5 for value - Absinthe.run" do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: \"#{Lorem.characters(4)}\"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "create Setting with validations length max 100 for value - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: \"#{Lorem.characters(101)}\"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSetting"]
    end

    test "create Setting with validations length max 100 for value - `Absinthe.run`" do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: \"#{Lorem.characters(101)}\"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "update specific setting by id - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateSetting"]
    end

    test "update specific setting by id - `Absinthe.run`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "return empty list setting for uncorrect settingId - `AbsintheHelpers`" do
      insert(:setting)
      setting_id = FlakeId.get()
      query = """
      mutation {
        updateSetting(
          id: \"#{setting_id}\",
          setting: {
           param: "updated some text"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateSetting"] == []
    end

    test "return empty list setting for uncorrect settingId - `Absinthe.run`" do
      insert(:setting)
      setting_id = FlakeId.get()
      query = """
      mutation {
        updateSetting(
          id: \"#{setting_id}\",
          setting: {
           param: "updated some text"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when unique_constraint param has been taken - `AbsintheHelpers`" do
      insert(:setting)
      struct = insert(:setting, param: "some text#2")
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "some text"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateSetting"] == []
    end

    test "returns empty list when unique_constraint param has been taken - `Absinthe.run`" do
      insert(:setting)
      struct = insert(:setting, param: "some text#2")
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "some text"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns nothing change for missing params - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateSetting"]
    end

    test "return nothing change for missing params - `Absinthe.run`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "return error setting when null is param - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
          param: nil
          value: nil
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"]
      |> String.replace("\"", "")
      |> String.replace("\n", "")
      |> String.replace("{", "")
      |> String.replace("}", "") ==
        "Argument setting has invalid value param: nil, value: nil.In field param: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "return error setting when null is param - `Absinthe.run`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
          param: nil
          value: nil
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: errors}} = Absinthe.run(query, Schema, context: nil)

      assert hd(errors).message
      |> String.replace("\"", "")
      |> String.replace("\"", "")
      |> String.replace("\n", "")
      |> String.replace("{", "")
      |> String.replace("}", "") ==
        "Argument setting has invalid value param: nil, value: nil.In field param: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "return empty list with validations length min 5 for param - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(4)}\"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateSetting"] == []
    end

    test "return empty list with validations length min 5 for param - `Absinthe.run`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(4)}\"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "return empty list with validations length max 100 for param - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(101)}\"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateSetting"] == []
    end

    test "return empty list with validations length max 100 for param - `Absinthe.run`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(101)}\"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "return empty list with validations length min 5 for value - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: \"#{Lorem.characters(4)}\"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateSetting"] == []
    end

    test "return empty list with validations length min 5 for value - `Absinthe.run`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: \"#{Lorem.characters(4)}\"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "return empty list with validations length max 100 for value - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: \"#{Lorem.characters(101)}\"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateSetting"] == []
    end

    test "return empty list with validations length max 100 for value - `Absinthe.run`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: \"#{Lorem.characters(101)}\"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end
  end

  describe "#list" do
    test "returns Setting with empty list - `AbsintheHelpers`" do
      query = """
      {
        listSetting {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "setting"))

      assert json_response(res, 200)["errors"] == nil
      [] = json_response(res, 200)["data"]["listSetting"]
    end

    test "returns Setting with empty list - `Absinthe.run`", context do
      query = """
      {
        listSetting {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"listSetting" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns listSetting - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      {
        listSetting {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "setting"))

      assert json_response(res, 200)["errors"] == nil
      data = json_response(res, 200)["data"]["listSetting"]
      assert List.first(data)["id"]    == struct.id
      assert List.first(data)["param"] == struct.param
      assert List.first(data)["value"] == struct.value
    end

    test "returns listSetting - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      {
        listSetting {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"listSetting" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]    == struct.id
      assert first["param"] == struct.param
      assert first["value"] == struct.value
    end
  end

  describe "#show" do
    test "returns specific setting by id - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      {
        showSetting(id: \"#{struct.id}\") {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "setting"))

      [found] = json_response(res, 200)["data"]["showSetting"]

      assert found["id"]    == struct.id
      assert found["param"] == struct.param
      assert found["value"] == struct.value
    end

    test "returns specific setting by id - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      {
        showSetting(id: \"#{struct.id}\") {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showSetting" => [found]}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]    == struct.id
      assert found["param"] == struct.param
      assert found["value"] == struct.value
    end

    test "returns empty list when setting does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      {
        showSetting(id: \"#{id}\") {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "setting"))

      assert json_response(res, 200)["data"]["showSetting"] == []
    end

    test "returns empty list when setting does not exist - `Absinthe.run`", context do
      id = FlakeId.get()

      query = """
      {
        showSetting(id: \"#{id}\") {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showSetting" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == []
    end

    test "returns error for missing params - `AbsintheHelpers`" do
      query = """
      {
        showSetting(id: nil) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "setting"))

      assert hd(json_response(res, 200)["errors"])["message"]
      |> String.replace("\"", "") == "Argument id has invalid value nil."
    end

    test "returns error for missing params - `Absinthe.run`", context do
      query = """
      {
        showSetting(id: nil) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: errors}} = Absinthe.run(query, Schema, context: context)
      assert hd(errors).message |> String.replace("\"", "") == "Argument id has invalid value nil."
    end
  end

  describe "#create" do
    test "creates setting - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [created] = json_response(res, 200)["data"]["createSetting"]

      assert created["param"] == "some text"
      assert created["value"] == "some text"
    end

    test "creates setting - `Absinthe.run`", context do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createSetting" => [created]}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["param"] == "some text"
      assert created["value"] == "some text"
    end

    test "returns empty list for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: nil
          value: nil
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"]
      |> String.replace("\"", "") == "Argument param has invalid value nil."
    end

    test "returns error for missing params - `Absinthe.run`", context do
      query = """
      mutation {
        createSetting(
          param: nil
          value: nil
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message |> String.replace("\"", "") == "Argument param has invalid value nil."
    end

    test "returns errors when unique_constraint param has been taken - `AbsintheHelpers`" do
      insert(:setting)
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSetting"]
    end

    test "returns errors when unique_constraint param has been taken - `Absinthe.run`", context do
      insert(:setting)
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createSetting" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "create Setting with validations length min 5 for param - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(4)}\"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSetting"]
    end

    test "create Setting with validations length min 5 for param - Absinthe.run", context do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(4)}\"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createSetting" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "create Setting with validations length max 100 for param - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(101)}\"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSetting"]
    end

    test "create Setting with validations length max 100 for param - Absinthe.run", context do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(101)}\"
          value: "some text"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createSetting" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "create Setting with validations length min 5 for value - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: \"#{Lorem.characters(4)}\"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSetting"]
    end

    test "create Setting with validations length min 5 for value - Absinthe.run", context do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: \"#{Lorem.characters(4)}\"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createSetting" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "create Setting with validations length max 100 for value - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: \"#{Lorem.characters(101)}\"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSetting"]
    end

    test "create Setting with validations length max 100 for value - `Absinthe.run`", context do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: \"#{Lorem.characters(101)}\"
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createSetting" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end
  end

  describe "#update" do
    test "update specific setting by id - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [updated] = json_response(res, 200)["data"]["updateSetting"]

      assert updated["id"]    == struct.id
      assert updated["param"] == "updated some text"
      assert updated["value"] == "updated some text"
    end

    test "update specific setting by id - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => [updated]}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]    == struct.id
      assert updated["param"] == "updated some text"
      assert updated["value"] == "updated some text"
    end

    test "return empty list setting for uncorrect settingId - `AbsintheHelpers`" do
      insert(:setting)
      setting_id = FlakeId.get()
      query = """
      mutation {
        updateSetting(
          id: \"#{setting_id}\",
          setting: {
           param: "updated some text"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateSetting"] == []
    end

    test "return empty list setting for uncorrect settingId - `Absinthe.run`", context do
      insert(:setting)
      setting_id = FlakeId.get()
      query = """
      mutation {
        updateSetting(
          id: \"#{setting_id}\",
          setting: {
           param: "updated some text"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when unique_constraint param has been taken - `AbsintheHelpers`" do
      insert(:setting)
      struct = insert(:setting, param: "some text#2")
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "some text"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateSetting"] == []
    end

    test "returns empty list when unique_constraint param has been taken - `Absinthe.run`", context do
      insert(:setting)
      struct = insert(:setting, param: "some text#2")
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "some text"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns nothing change for missing params - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [updated] = json_response(res, 200)["data"]["updateSetting"]

      assert updated["id"]    == struct.id
      assert updated["param"] == struct.param
      assert updated["value"] == struct.value
    end

    test "return nothing change for missing params - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => [updated]}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]    == struct.id
      assert updated["param"] == struct.param
      assert updated["value"] == struct.value
    end

    test "return error setting when null is param - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
          param: nil
          value: nil
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))


      assert hd(json_response(res, 200)["errors"])["message"]
      |> String.replace("\"", "")
      |> String.replace("\n", "")
      |> String.replace("{", "")
      |> String.replace("}", "") ==
      "Argument setting has invalid value param: nil, value: nil.In field param: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "return error setting when null is param - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
          param: nil
          value: nil
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: errors}} = Absinthe.run(query, Schema, context: context)
      assert hd(errors).message
      |> String.replace("\"", "")
      |> String.replace("\n", "")
      |> String.replace("{", "")
      |> String.replace("}", "") ==
      "Argument setting has invalid value param: nil, value: nil.In field param: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "return empty list with validations length min 5 for param - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(4)}\"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateSetting"] == []
    end

    test "return empty list with validations length min 5 for param - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(4)}\"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "return empty list with validations length max 100 for param - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(101)}\"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateSetting"] == []
    end

    test "return empty list with validations length max 100 for param - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(101)}\"
           value: "updated some text"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "return empty list with validations length min 5 for value - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: \"#{Lorem.characters(4)}\"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateSetting"] == []
    end

    test "return empty list with validations length min 5 for value - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: \"#{Lorem.characters(4)}\"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "return empty list with validations length max 100 for value - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: \"#{Lorem.characters(101)}\"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateSetting"] == []
    end

    test "return empty list with validations length max 100 for value - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: \"#{Lorem.characters(101)}\"
          }
        ) {
          id
          param
          value
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateSetting" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end
  end
end
