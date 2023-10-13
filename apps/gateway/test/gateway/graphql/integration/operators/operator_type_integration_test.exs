defmodule Gateway.GraphQL.Integration.Operators.OperatorTypeIntegrationTest do
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
    test "returns OperatorType with empty list - `AbsintheHelpers`" do
      query = """
      {
        listOperatorType {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator_type"))

      assert json_response(res, 200)["errors"] == nil
      [] = json_response(res, 200)["data"]["listOperatorType"]
    end

    test "returns OperatorType with empty list - `Absinthe.run`" do
      query = """
      {
        listOperatorType {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"listOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns listOperatorType - `AbsintheHelpers`" do
      query = """
      {
        listOperatorType {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator_type"))

      [] = json_response(res, 200)["data"]["listOperatorType"]
    end

    test "returns listOperatorType - `Absinthe.run`" do
      query = """
      {
        listOperatorType {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"listOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns specific operatorType by id - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      {
        showOperatorType(id: \"#{struct.id}\") {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator_type"))

      [] = json_response(res, 200)["data"]["showOperatorType"]
    end

    test "returns specific operatorType by id - `Absinthe.run`" do
      struct = insert(:operator_type)
      query = """
      {
        showOperatorType(id: \"#{struct.id}\") {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when operatorType does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      query = """
      {
        showOperatorType(id: \"#{id}\") {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator_type"))

      assert json_response(res, 200)["data"]["showOperatorType"] == []
    end

    test "returns empty list when operatorType does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      query = """
      {
        showOperatorType(id: \"#{id}\") {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns error for missing params - `AbsintheHelpers`" do
      query = """
      {
        showOperatorType(id: nil) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator_type"))

      assert hd(json_response(res, 200)["errors"])["message"]
      |> String.replace("\"", "") == "Argument id has invalid value nil."
    end

    test "returns error for missing params - `Absinthe.run`" do
      query = """
      {
        showOperatorType(id: nil) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: errors}} = Absinthe.run(query, Schema, context: nil)
      assert hd(errors).message |> String.replace("\"", "") == "Argument id has invalid value nil."
    end

    test "creates operatorType - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperatorType"]
    end

    test "creates operatorType - `Absinthe.run`" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created returns empty list for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperatorType(
          active: nil
          name_type: nil
          priority: nil
        ) {
          id
          active
          name_type
          priority
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
      |> String.replace("\"", "") == "Argument active has invalid value nil."
    end

    test "created returns error for missing params - `Absinthe.run`" do
      query = """
      mutation {
        createOperatorType(
          active: nil
          name_type: nil
          priority: nil
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: nil)

      assert hd(error).message |> String.replace("\"", "") == "Argument active has invalid value nil."
    end

    test "returns errors when unique_constraint nameType has been taken - `AbsintheHelpers`" do
      insert(:operator_type)
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperatorType"]
    end

    test "returns errors when unique_constraint nameType has been taken - `Absinthe.run`" do
      insert(:operator_type)
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "create OperatorType with validations length min 3 for nameType - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: \"#{Lorem.characters(2)}\"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperatorType"]
    end

    test "create OperatorType with validations length min 3 for nameType - Absinthe.run" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: \"#{Lorem.characters(2)}\"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "create OperatorType with validations length max 100 for nameType - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: \"#{Lorem.characters(101)}\"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperatorType"]
    end

    test "create OperatorType with validations length max 100 for nameType - Absinthe.run" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: \"#{Lorem.characters(101)}\"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "create OperatorType with validations integer min 1 for priority - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: #{Faker.random_between(0, 0)}
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperatorType"]
    end

    test "create OperatorType with validations integer min 1 for priority - Absinthe.run" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: #{Faker.random_between(0, 0)}
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "create OperatorType with validations integer max 99 for priority - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: #{Faker.random_between(100, 101)}
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperatorType"]
    end

    test "create OperatorType with validations integer max 100 for priority - `Absinthe.run`" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: #{Faker.random_between(100, 101)}
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "update specific operatorType by id - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperatorType"]
    end

    test "update specific operatorType by id - `Absinthe.run`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "return empty list operatorType for uncorrect operatorTypeId - `AbsintheHelpers`" do
      insert(:operator_type)
      operator_type_id = FlakeId.get()
      query = """
      mutation {
        updateOperatorType(
          id: \"#{operator_type_id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateOperatorType"] == []
    end

    test "return empty list operatorType for uncorrect operatorTypeId - `Absinthe.run`" do
      insert(:operator_type)
      operator_type_id = FlakeId.get()
      query = """
      mutation {
        updateOperatorType(
          id: \"#{operator_type_id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when unique_constraint nameType has been taken - `AbsintheHelpers`" do
      insert(:operator_type)
      struct = insert(:operator_type, name_type: "some text#2")
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "some text"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateOperatorType"] == []
    end

    test "returns empty list when unique_constraint nameType has been taken - `Absinthe.run`" do
      insert(:operator_type)
      struct = insert(:operator_type, name_type: "some text#2")
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "some text"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns nothing change for missing params - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operatorType: {
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperatorType"]
    end

    test "return nothing change for missing params - `Absinthe.run`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "return error operatorType when null is nameType - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          setting: {
            active: nil
            name_type: nil
            priority: nil
          }
        ) {
          id
          active
          name_type
          priority
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
      "Unknown argument setting on field updateOperatorType of type RootMutationType."
    end

    test "return error operatorType when null is nameType - `Absinthe.run`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: nil
            param: nil
            value: nil
          }
        ) {
          id
          active
          name_type
          priority
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
      "Argument operator_type has invalid value active: nil, param: nil, value: nil.In field active: Expected type Boolean, found nil.In field param: Unknown field.In field value: Unknown field."
    end

    test "return empty list with validations length min 3 for nameType - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: \"#{Lorem.characters(2)}\"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateOperatorType"] == []
    end

    test "return empty list with validations length min 3 for nameType - `Absinthe.run`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: \"#{Lorem.characters(2)}\"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "return empty list with validations length max 100 for nameType - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: \"#{Lorem.characters(101)}\"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateOperatorType"] == []
    end

    test "return empty list with validations length max 100 for nameType - `Absinthe.run`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: \"#{Lorem.characters(101)}\"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "return empty list with validations integer min 1 for priority - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: #{Faker.random_between(0, 0)}
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateOperatorType"] == []
    end

    test "return empty list with validations integer min 1 for priority - `Absinthe.run`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: #{Faker.random_between(0, 0)}
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "return empty list with validations integer max 99 for priority - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: #{Faker.random_between(100, 103)}
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateOperatorType"] == []
    end

    test "return empty list with validations integer max 99 for priority - `Absinthe.run`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: #{Faker.random_between(100, 103)}
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end
  end

  describe "#list" do
    test "returns OperatorType with empty list - `AbsintheHelpers`" do
      query = """
      {
        listOperatorType {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator_type"))

      assert json_response(res, 200)["errors"] == nil
      [] = json_response(res, 200)["data"]["listOperatorType"]
    end

    test "returns OperatorType with empty list - `Absinthe.run`", context do
      query = """
      {
        listOperatorType {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"listOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns listOperatorType - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      {
        listOperatorType {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator_type"))

      assert json_response(res, 200)["errors"] == nil
      data = json_response(res, 200)["data"]["listOperatorType"]
      assert List.first(data)["id"]        == struct.id
      assert List.first(data)["active"]    == struct.active
      assert List.first(data)["name_type"] == struct.name_type
      assert List.first(data)["priority"]  == struct.priority
    end

    test "returns listOperatorType - `Absinthe.run`", context do
      struct = insert(:operator_type)
      query = """
      {
        listOperatorType {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"listOperatorType" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]        == struct.id
      assert first["active"]    == struct.active
      assert first["name_type"] == struct.name_type
      assert first["priority"]  == struct.priority
    end
  end

  describe "#show" do
    test "returns specific operatorType by id - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      {
        showOperatorType(id: \"#{struct.id}\") {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator_type"))

      [found] = json_response(res, 200)["data"]["showOperatorType"]

      assert found["id"]       == struct.id
      assert found["active"]   == struct.active
      assert found["name_type"] == struct.name_type
      assert found["priority"] == struct.priority
    end

    test "returns specific operatorType by id - `Absinthe.run`", context do
      struct = insert(:operator_type)
      query = """
      {
        showOperatorType(id: \"#{struct.id}\") {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showOperatorType" => [found]}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]       == struct.id
      assert found["active"]   == struct.active
      assert found["name_type"] == struct.name_type
      assert found["priority"] == struct.priority
    end

    test "returns empty list when operatorType does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      query = """
      {
        showOperatorType(id: \"#{id}\") {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator_type"))

      assert json_response(res, 200)["data"]["showOperatorType"] == []
    end

    test "returns empty list when operatorType does not exist - `Absinthe.run`", context do
      id = FlakeId.get()
      query = """
      {
        showOperatorType(id: \"#{id}\") {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showOperatorType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == []
    end

    test "returns error for missing params - `AbsintheHelpers`" do
      query = """
      {
        showOperatorType(id: nil) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator_type"))

      assert hd(json_response(res, 200)["errors"])["message"]
      |> String.replace("\"", "") == "Argument id has invalid value nil."
    end

    test "returns error for missing params - `Absinthe.run`", context do
      query = """
      {
        showOperatorType(id: nil) {
          id
          active
          name_type
          priority
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
    test "creates operatorType - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [created] = json_response(res, 200)["data"]["createOperatorType"]

      assert created["active"]    == true
      assert created["name_type"] == "some text"
      assert created["priority"]  == 1
    end

    test "creates operatorType - `Absinthe.run`", context do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperatorType" => [created]}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["active"]   == true
      assert created["name_type"] == "some text"
      assert created["priority"] == 1
    end

    test "returns empty list for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperatorType(
          active: nil
          name_type: nil
          priority: nil
        ) {
          id
          active
          name_type
          priority
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
      |> String.replace("\"", "") == "Argument active has invalid value nil."
    end

    test "returns error for missing params - `Absinthe.run`", context do
      query = """
      mutation {
        createOperatorType(
          active: nil
          name_type: nil
          priority: nil
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message |> String.replace("\"", "") == "Argument active has invalid value nil."
    end

    test "returns errors when unique_constraint nameType has been taken - `AbsintheHelpers`" do
      insert(:operator_type)
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperatorType"]
    end

    test "returns errors when unique_constraint nameType has been taken - `Absinthe.run`", context do
      insert(:operator_type)
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "create OperatorType with validations length min 3 for nameType - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: \"#{Lorem.characters(2)}\"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperatorType"]
    end

    test "create OperatorType with validations length min 3 for nameType - Absinthe.run", context do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: \"#{Lorem.characters(2)}\"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "create OperatorType with validations length max 100 for nameType - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: \"#{Lorem.characters(101)}\"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperatorType"]
    end

    test "create OperatorType with validations length max 100 for nameType - Absinthe.run", context do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: \"#{Lorem.characters(101)}\"
          priority: 1
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "create OperatorType with validations integer min 1 for priority - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: #{Faker.random_between(0, 0)}
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperatorType"]
    end

    test "create OperatorType with validations integer min 1 for priority - Absinthe.run", context do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: #{Faker.random_between(0, 0)}
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "create OperatorType with validations integer max 99 for priority - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: #{Faker.random_between(100, 101)}
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperatorType"]
    end

    test "create OperatorType with validations integer max 100 for priority - `Absinthe.run`", context do
      query = """
      mutation {
        createOperatorType(
          active: true
          name_type: "some text"
          priority: #{Faker.random_between(100, 101)}
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end
  end

  describe "#update" do
    test "update specific operatorType by id - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [updated] = json_response(res, 200)["data"]["updateOperatorType"]

      assert updated["id"]        == struct.id
      assert updated["active"]    == false
      assert updated["name_type"]  == "updated some text"
      assert updated["priority"]  == 2
    end

    test "update specific operatorType by id - `Absinthe.run`", context do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => [updated]}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]       == struct.id
      assert updated["active"]   == false
      assert updated["name_type"] == "updated some text"
      assert updated["priority"] == 2
    end

    test "return empty list operatorType for uncorrect operatorTypeId - `AbsintheHelpers`" do
      insert(:operator_type)
      operator_type_id = FlakeId.get()
      query = """
      mutation {
        updateOperatorType(
          id: \"#{operator_type_id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateOperatorType"] == []
    end

    test "return empty list operatorType for uncorrect operatorTypeId - `Absinthe.run`", context do
      insert(:operator_type)
      operator_type_id = FlakeId.get()
      query = """
      mutation {
        updateOperatorType(
          id: \"#{operator_type_id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when unique_constraint nameType has been taken - `AbsintheHelpers`" do
      insert(:operator_type)
      struct = insert(:operator_type, name_type: "some text#2")
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "some text"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateOperatorType"] == []
    end

    test "returns empty list when unique_constraint nameType has been taken - `Absinthe.run`", context do
      insert(:operator_type)
      struct = insert(:operator_type, name_type: "some text#2")
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "some text"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns nothing change for missing params - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operatorType: {
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [updated] = json_response(res, 200)["data"]["updateOperatorType"]

      assert updated["id"]       == struct.id
      assert updated["active"]   == struct.active
      assert updated["name_type"] == struct.name_type
      assert updated["priority"] == struct.priority
    end

    test "return nothing change for missing params - `Absinthe.run`", context do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => [updated]}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]       == struct.id
      assert updated["active"]   == struct.active
      assert updated["name_type"] == struct.name_type
      assert updated["priority"] == struct.priority
    end

    test "return error operatorType when null is nameType - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          setting: {
            active: nil
            name_type: nil
            priority: nil
          }
        ) {
          id
          active
          name_type
          priority
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
      "Unknown argument setting on field updateOperatorType of type RootMutationType."
    end

    test "return error operatorType when null is nameType - `Absinthe.run`", context do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: nil
            param: nil
            value: nil
          }
        ) {
          id
          active
          name_type
          priority
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
      "Argument operator_type has invalid value active: nil, param: nil, value: nil.In field active: Expected type Boolean, found nil.In field param: Unknown field.In field value: Unknown field."
    end

    test "return empty list with validations length min 3 for nameType - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: \"#{Lorem.characters(2)}\"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateOperatorType"] == []
    end

    test "return empty list with validations length min 3 for nameType - `Absinthe.run`", context do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: \"#{Lorem.characters(2)}\"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "return empty list with validations length max 100 for nameType - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: \"#{Lorem.characters(101)}\"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateOperatorType"] == []
    end

    test "return empty list with validations length max 100 for nameType - `Absinthe.run`", context do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: \"#{Lorem.characters(101)}\"
            priority: 2
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "return empty list with validations integer min 1 for priority - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: #{Faker.random_between(0, 0)}
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateOperatorType"] == []
    end

    test "return empty list with validations integer min 1 for priority - `Absinthe.run`", context do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: #{Faker.random_between(0, 0)}
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "return empty list with validations integer max 99 for priority - `AbsintheHelpers`" do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: #{Faker.random_between(100, 103)}
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["data"]["updateOperatorType"] == []
    end

    test "return empty list with validations integer max 99 for priority - `Absinthe.run`", context do
      struct = insert(:operator_type)
      query = """
      mutation {
        updateOperatorType(
          id: \"#{struct.id}\",
          operator_type: {
            active: false
            name_type: "updated some text"
            priority: #{Faker.random_between(100, 103)}
          }
        ) {
          id
          active
          name_type
          priority
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperatorType" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end
  end
end
