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

      assert json_response(res, 200)["errors"] == nil
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

    test "show returns specific setting by id - `AbsintheHelpers`" do
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

    test "show returns specific setting by id - `Absinthe.run`" do
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

    test "show returns empty list when setting does not exist - `AbsintheHelpers`" do
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

    test "show returns empty list when setting does not exist - `Absinthe.run`" do
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

    test "show returns error for missing params - `AbsintheHelpers`" do
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

      assert hd(json_response(res, 200)["errors"])["message"]
      |> String.replace("\"", "") == "Argument id has invalid value nil."
    end

    test "show returns error for missing params - `Absinthe.run`" do
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

    test "created setting - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: "calc_priority"
          value: "priority"
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

    test "created setting - `Absinthe.run`" do
      query = """
      mutation {
        createSetting(
          param: "calc_priority"
          value: "priority"
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

    test "created returns empty list for missing params - `AbsintheHelpers`" do
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

    test "created returns error for missing params - `Absinthe.run`" do
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

      assert hd(error).message |> String.replace("\"", "") == "Argument param has invalid value nil."
    end

    test "created returns errors when unique_constraint param has been taken - `AbsintheHelpers`" do
      insert(:setting)
      query = """
      mutation {
        createSetting(
          param: "calc_priority"
          value: "priority"
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

    test "created returns errors when unique_constraint param has been taken - `Absinthe.run`" do
      insert(:setting)
      query = """
      mutation {
        createSetting(
          param: "calc_priority"
          value: "priority"
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

    test "created Setting with validations length min 5 for param - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(4)}\"
          value: "priority"
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

    test "created Setting with validations length min 5 for param - Absinthe.run" do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(4)}\"
          value: "priority"
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

    test "created Setting with validations length max 100 for param - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(101)}\"
          value: "priority"
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

    test "created Setting with validations length max 100 for param - Absinthe.run" do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(101)}\"
          value: "priority"
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

    test "created Setting enum for value - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: "hello"
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

    test "created Setting enum for value - Absinthe.run" do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: "hello"
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

    test "updated specific setting by id - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "calc_priority"
           value: "priceext_priceint"
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

    test "updated specific setting by id - `Absinthe.run`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "calc_priority"
           value: "priceext_priceint"
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

    test "updated return empty list setting for uncorrect settingId - `AbsintheHelpers`" do
      insert(:setting)
      setting_id = FlakeId.get()
      query = """
      mutation {
        updateSetting(
          id: \"#{setting_id}\",
          setting: {
           param: "calc_priority"
           value: "priceext_priceint"
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

    test "updated return empty list setting for uncorrect settingId - `Absinthe.run`" do
      insert(:setting)
      setting_id = FlakeId.get()
      query = """
      mutation {
        updateSetting(
          id: \"#{setting_id}\",
          setting: {
           param: "calc_priority"
           value: "priceext_priceint"
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

    test "updated returns empty list when unique_constraint param has been taken - `AbsintheHelpers`" do
      insert(:setting)
      struct = insert(:setting, param: "some text")
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "calc_priority"
           value: "priceext_priceint"
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

    test "updated returns empty list when unique_constraint param has been taken - `Absinthe.run`" do
      insert(:setting)
      struct = insert(:setting, param: "some text")
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "calc_priority"
           value: "priceext_priceint"
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

    test "updated returns nothing change for missing params - `AbsintheHelpers`" do
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

    test "updated returns nothing change for missing params - `Absinthe.run`" do
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

    test "updated returns error setting when null is param - `AbsintheHelpers`" do
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

    test "updated returns error setting when null is param - `Absinthe.run`" do
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
      |> String.replace("\n", "")
      |> String.replace("{", "")
      |> String.replace("}", "") ==
      "Argument setting has invalid value param: nil, value: nil.In field param: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "updated returns empty list with validations length min 5 for param - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(4)}\"
           value: "priceext_priceint"
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

    test "updated returns empty list with validations length min 5 for param - `Absinthe.run`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(4)}\"
           value: "priceext_priceint"
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

    test "updated returns empty list with validations length max 100 for param - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(101)}\"
           value: "priceext_priceint"
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

    test "updated returns empty list with validations length max 100 for param - `Absinthe.run`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(101)}\"
           value: "priceext_priceint"
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

    test "updated returns empty list enum for value - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: "hello"
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

    test "updated returns empty list enum for value - `Absinthe.run`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: "hello"
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
      assert List.first(data)["value"] == "priority"
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
      assert first["value"] == "priority"
    end
  end

  describe "#show" do
    test "show returns specific setting by id - `AbsintheHelpers`" do
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
      assert found["value"] == "priority"
    end

    test "show returns specific setting by id - `Absinthe.run`", context do
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
      assert found["value"] == "priority"
    end

    test "show returns empty list when setting does not exist - `AbsintheHelpers`" do
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

    test "show returns empty list when setting does not exist - `Absinthe.run`", context do
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

    test "show returns error for missing params - `AbsintheHelpers`" do
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

    test "show returns error for missing params - `Absinthe.run`", context do
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
    test "created setting - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: "calc_priority"
          value: "priority"
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

      assert created["param"] == "calc_priority"
      assert created["value"] == "priority"
    end

    test "created setting - `Absinthe.run`", context do
      query = """
      mutation {
        createSetting(
          param: "calc_priority"
          value: "priority"
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

      assert created["param"] == "calc_priority"
      assert created["value"] == "priority"
    end

    test "created returns empty list for missing params - `AbsintheHelpers`" do
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

    test "created returns error for missing params - `Absinthe.run`", context do
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

    test "created returns errors when unique_constraint param has been taken - `AbsintheHelpers`" do
      insert(:setting)
      query = """
      mutation {
        createSetting(
          param: "calc_priority"
          value: "priority"
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

    test "created returns errors when unique_constraint param has been taken - `Absinthe.run`", context do
      insert(:setting)
      query = """
      mutation {
        createSetting(
          param: "calc_priority"
          value: "priority"
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

    test "created Setting with validations length min 5 for param - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(4)}\"
          value: "priority"
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

    test "created Setting with validations length min 5 for param - Absinthe.run", context do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(4)}\"
          value: "priority"
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

    test "created Setting with validations length max 100 for param - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(101)}\"
          value: "priority"
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

    test "created Setting with validations length max 100 for param - Absinthe.run", context do
      query = """
      mutation {
        createSetting(
          param: \"#{Lorem.characters(101)}\"
          value: "priority"
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

    test "created Setting enum for value - `AbsintheHelpers`" do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: "hello"
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

    test "created Setting enum for value - Absinthe.run", context do
      query = """
      mutation {
        createSetting(
          param: "some text"
          value: "hello"
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
    test "updated specific setting by id - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "calc_priority"
           value: "priceext_priceint"
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
      assert updated["param"] == "calc_priority"
      assert updated["value"] == "priceext_priceint"
    end

    test "updated specific setting by id - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "calc_priority"
           value: "priceext_priceint"
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
      assert updated["param"] == "calc_priority"
      assert updated["value"] == "priceext_priceint"
    end

    test "updated returns empty list setting for uncorrect settingId - `AbsintheHelpers`" do
      insert(:setting)
      setting_id = FlakeId.get()
      query = """
      mutation {
        updateSetting(
          id: \"#{setting_id}\",
          setting: {
           param: "calc_priority"
           value: "priceext_priceint"
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

    test "updated returns empty list setting for uncorrect settingId - `Absinthe.run`", context do
      insert(:setting)
      setting_id = FlakeId.get()
      query = """
      mutation {
        updateSetting(
          id: \"#{setting_id}\",
          setting: {
           param: "calc_priority"
           value: "priceext_priceint"
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

    test "updated returns empty list when unique_constraint param has been taken - `AbsintheHelpers`" do
      insert(:setting)
      struct = insert(:setting, param: "some text")
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "calc_priority"
           value: "priceext_priceint"
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

    test "updated returns empty list when unique_constraint param has been taken - `Absinthe.run`", context do
      insert(:setting)
      struct = insert(:setting, param: "some text")
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "calc_priority"
           value: "priceext_priceint"
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

    test "updated returns nothing change for missing params - `AbsintheHelpers`" do
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
      assert updated["value"] == "priority"
    end

    test "updated returns nothing change for missing params - `Absinthe.run`", context do
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
      assert updated["value"] == "priority"
    end

    test "updated returns error setting when null is param - `AbsintheHelpers`" do
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

    test "updated returns error setting when null is param - `Absinthe.run`", context do
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

    test "updated returns empty list with validations length min 5 for param - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(4)}\"
           value: "priceext_priceint"
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

    test "updated returns empty list with validations length min 5 for param - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(4)}\"
           value: "priceext_priceint"
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

    test "updated returns empty list with validations length max 100 for param - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(101)}\"
           value: "priceext_priceint"
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

    test "updated returns empty list with validations length max 100 for param - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: \"#{Lorem.characters(101)}\"
           value: "priceext_priceint"
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

    test "updated returns empty list enum for value - `AbsintheHelpers`" do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: "hello"
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

    test "updated returns empty list enum for value - `Absinthe.run`", context do
      struct = insert(:setting)
      query = """
      mutation {
        updateSetting(
          id: \"#{struct.id}\",
          setting: {
           param: "updated some text"
           value: "hello"
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
