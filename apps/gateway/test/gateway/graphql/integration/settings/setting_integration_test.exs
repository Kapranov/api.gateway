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

      assert json_response(res, 200)["data"]["listSetting"] == []
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

      {:ok, %{data: %{"listSetting" => data}}} =
        Absinthe.run(query, Schema, context: nil)

      assert data == []
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

      assert json_response(res, 200)["data"]["showSetting"] == []
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
  end

  describe "#list" do
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
      assert List.first(data)["id"]          == struct.id
      assert List.first(data)["param"]       == struct.param
      assert List.first(data)["value"]       == struct.value
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

      assert found["id"]          == struct.id
      assert found["param"]       == struct.param
      assert found["value"]       == struct.value
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

      assert found["id"]          == struct.id
      assert found["param"]       == struct.param
      assert found["value"]       == struct.value
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

      assert json_response(res, 200)["errors"] == [
        %{
          "locations" => [%{"column" => 15, "line" => 2}],
          "message" => "Argument \"id\" has invalid value nil."
        }
      ]
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

      {:ok, %{errors: [%{
        message: "Argument \"id\" has invalid value nil.",
        locations: [%{line: 2, column: 15}]
      }]}} = Absinthe.run(query, Schema, context: context)
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

      assert created["param"]       == "some text"
      assert created["value"]       == "some text"
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

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"param\" has invalid value nil."
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

      assert hd(error).message == "Argument \"param\" has invalid value nil."
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


      assert updated["id"]          == struct.id
      assert updated["param"]       == "updated some text"
      assert updated["value"]       == "updated some text"
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

      assert updated["id"]          == struct.id
      assert updated["param"]       == "updated some text"
      assert updated["value"]       == "updated some text"
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

    test "return same data setting when missing param - `AbsintheHelpers`" do
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

      assert updated["id"]          == struct.id
      assert updated["param"]       == struct.param
      assert updated["value"]       == struct.value
    end

    test "return same data setting when missing param - `Absinthe.run`", context do
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

      assert updated["id"]          == struct.id
      assert updated["param"]       == struct.param
      assert updated["value"]       == struct.value
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


      assert json_response(res, 200)["errors"] == [
        %{
          "locations" => [%{"column" => 5, "line" => 4}],
          "message" => "Argument \"setting\" has invalid value {param: nil, value: nil}.\nIn field \"param\": Expected type \"String\", found nil.\nIn field \"value\": Expected type \"String\", found nil."
        }
      ]
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
      {:ok, %{errors: [%{
        locations: [%{line: 4, column: 5}],
        message: "Argument \"setting\" has invalid value {param: nil, value: nil}.\nIn field \"param\": Expected type \"String\", found nil.\nIn field \"value\": Expected type \"String\", found nil."
      }]}} = Absinthe.run(query, Schema, context: context)
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
