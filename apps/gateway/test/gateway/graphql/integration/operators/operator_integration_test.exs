defmodule Gateway.GraphQL.Integration.Operators.OperatorIntegrationTest do
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
    test "returns Operator with empty list - `AbsintheHelpers`" do
      query = """
      {
        listOperator {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limitCount
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator"))

      assert json_response(res, 200)["errors"] == nil
      [] = json_response(res, 200)["data"]["listOperator"]
    end

    test "returns Operator with empty list - `Absinthe.run`" do
      query = """
      {
        listOperator {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limitCount
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"listOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns Operator with data - `AbsintheHelpers`" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        listOperator {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limit_count
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator"))

      assert json_response(res, 200)["errors"] == nil
      [] = json_response(res, 200)["data"]["listOperator"]
    end

    test "returns Operator with data - `Absinthe.run`" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        listOperator {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limit_count
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"listOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns specific OperatorId - `AbsintheHelpers`" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showOperator(id: \"#{operator.id}\") {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limit_count
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator"))

      [] = json_response(res, 200)["data"]["showOperator"]
    end

    test "returns specific OperatorId - `Absinthe.run`" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showOperator(id: \"#{operator.id}\") {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limit_count
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when Operator does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      query = """
      {
        showOperator(id: \"#{id}\") {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limit_count
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator"))

      assert json_response(res, 200)["data"]["showOperator"] == []
    end

    test "returns empty list when Operator does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      query = """
      {
        showOperator(id: \"#{id}\") {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limit_count
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Operator - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created Operator - `Absinthe.run`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created returns error when missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperator(
          active: nil
          config: {
            content_type: "some text"
            name: nil
            parameters: { key: nil, value: nil }
            size: 1
            url: nil
          }
          limit_count: 1
          name_operator: nil
          operator_type_id: nil
          phone_code: "063, 093, 096"
          price_ext: nil
          price_int: nil
          priority: nil
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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

    test "created returns error when missing params - `Absinthe.run`" do
      query = """
      mutation {
        createOperator(
          active: nil
          config: {
            content_type: "some text"
            name: nil
            parameters: { key: nil, value: nil }
            size: 1
            url: nil
          }
          limit_count: 1
          name_operator: nil
          operator_type_id: nil
          phone_code: "063, 093, 096"
          price_ext: nil
          price_int: nil
          priority: nil
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: nil)
      assert hd(error).message |> String.replace("\"", "") == "Argument active has invalid value nil."
    end

    test "created returns error when config invalid - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: nil
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: nil
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument config has invalid value content_type: some text, name: nil, parameters: key: some text, value: some text, size: 1, url: nil.In field name: Expected type String, found nil.In field url: Expected type String, found nil."
    end

    test "created returns error when config invalid - `Absinthe.run" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: nil
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: nil
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: nil)
      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument config has invalid value content_type: some text, name: nil, parameters: key: some text, value: some text, size: 1, url: nil.In field name: Expected type String, found nil.In field url: Expected type String, found nil."
    end

    test "created returns error when parameters invalid - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: nil, value: nil }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument config has invalid value content_type: some text, name: some text, parameters: key: nil, value: nil, size: 1, url: some text.In field parameters: Expected type UpdateParameters!, found key: nil, value: nil.In field key: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "created returns error when parameters invalid - `Absinthe.run" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: nil, value: nil }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: nil)
      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument config has invalid value content_type: some text, name: some text, parameters: key: nil, value: nil, size: 1, url: some text.In field parameters: Expected type UpdateParameters!, found key: nil, value: nil.In field key: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "created returns empty list when uniqueConstraint nameOperator has been taken - `AbsintheHelpers`" do
      insert(:operator, name_operator: "some text")
      operator_type = insert(:operator_type, name_type: "some text#2")
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when uniqueConstraint nameOperator has been taken - `Absinthe.run" do
      insert(:operator, name_operator: "some text")
      operator_type = insert(:operator_type, name_type: "some text#2")
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created returns empty list when none exist operatorTypeId - `AbsintheHelpers`" do
      operator_type_id = FlakeId.get()
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type_id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when none exist operatorTypeId - `Absinthe.run`" do
      operator_type_id = FlakeId.get()
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type_id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created returns empty list when validations length min 3 for nameOperator - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: \"#{Lorem.characters(2)}\"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when validations length min 3 for nameOperator - `Absinthe.run`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: \"#{Lorem.characters(2)}\"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created returns empty list when validations length max 100 for nameOperator - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: \"#{Lorem.characters(101)}\"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when validations length max 100 for nameOperator - `Absinthe.run`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: \"#{Lorem.characters(101)}\"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created returns empty list when validations length max 100_000 for limitCount - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: #{Faker.random_between(101_000, 102_000)}
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when validations length max 100_000 for limitCount - `Absinthe.run`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: #{Faker.random_between(101_000, 102_000)}
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created returns empty list when validations integer min 1 for priority - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: #{Faker.random_between(0, 0)}
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when validations integer min 1 for priority - `Absinthe.run`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: #{Faker.random_between(0, 0)}
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created returns empty list when validations integer max 99 for priority - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: #{Faker.random_between(100, 101)}
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when validations integer max 99 for priority - `Absinthe.run`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: #{Faker.random_between(100, 101)}
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created returns error when validations decimal priceExt - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: "hello"
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("\"", "") ==
      "Argument price_ext has invalid value hello."
    end

    test "created returns error when validations decimal priceExt - `Absinthe.run`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: "hello"
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: nil)
      assert hd(error).message
      |> String.replace("\"", "")
      "Argument price_ext has invalid value hello."
    end

    test "created returns error when validations decimal priceInt - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: "hello"
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("\"", "") ==
      "Argument price_int has invalid value hello."
    end

    test "created returns error when validations decimal priceInt - `Absinthe.run`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: "hello"
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: nil)
      assert hd(error).message
      |> String.replace("\"", "") ==
      "Argument price_int has invalid value hello."
    end

    test "update specific OperatorId - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "update specific OperatorId - `Absinthe.run`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """

      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "update specific OperatorId with embed config and parameters - `AbsintheHelpers`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "update specific OperatorId with embed config and parameters - `Absinthe.run`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated nothing change for missing params - `AbsintheHelpers`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated nothing change for missing params - `Absinthe.run`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated returns error for missing params - `AbsintheHelpers`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: nil
            config: {
              content_type: "updated some text"
              name: nil
              parameters: { key: nil, value: nil }
              size: 2
              url: nil
            }
            limit_count: 2
            name_operator: nil
            operator_type_id: nil
            phone_code: "063"
            price_ext: nil
            price_int: nil
            priority: nil
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: nil, config: content_type: updated some text, name: nil, parameters: key: nil, value: nil, size: 2, url: nil, limit_count: 2, name_operator: nil, operator_type_id: nil, phone_code: 063, price_ext: nil, price_int: nil, priority: nil.In field active: Expected type Boolean, found nil.In field config: Expected type UpdateConfig, found content_type: updated some text, name: nil, parameters: key: nil, value: nil, size: 2, url: nil.In field name: Expected type String, found nil.In field parameters: Expected type UpdateParameters!, found key: nil, value: nil.In field key: Expected type String, found nil.In field value: Expected type String, found nil.In field url: Expected type String, found nil.In field name_operator: Expected type String, found nil.In field operator_type_id: Expected type String, found nil.In field price_ext: Expected type Decimal, found nil.In field price_int: Expected type Decimal, found nil.In field priority: Expected type Int, found nil."
    end

    test "updated returns error for missing params - `Absinthe.run`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: nil
            config: {
              content_type: "updated some text"
              name: nil
              parameters: { key: nil, value: nil }
              size: 2
              url: nil
            }
            limit_count: 2
            name_operator: nil
            operator_type_id: nil
            phone_code: "063"
            price_ext: nil
            price_int: nil
            priority: nil
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: nil)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: nil, config: content_type: updated some text, name: nil, parameters: key: nil, value: nil, size: 2, url: nil, limit_count: 2, name_operator: nil, operator_type_id: nil, phone_code: 063, price_ext: nil, price_int: nil, priority: nil.In field active: Expected type Boolean, found nil.In field config: Expected type UpdateConfig, found content_type: updated some text, name: nil, parameters: key: nil, value: nil, size: 2, url: nil.In field name: Expected type String, found nil.In field parameters: Expected type UpdateParameters!, found key: nil, value: nil.In field key: Expected type String, found nil.In field value: Expected type String, found nil.In field url: Expected type String, found nil.In field name_operator: Expected type String, found nil.In field operator_type_id: Expected type String, found nil.In field price_ext: Expected type Decimal, found nil.In field price_int: Expected type Decimal, found nil.In field priority: Expected type Int, found nil."
    end

    test "updated returns error when embed config is invalid - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: nil
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: nil
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: nil, parameters: key: updated some text, value: updated some text, size: 2, url: nil, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: 2, price_int: 2, priority: 2.In field config: Expected type UpdateConfig, found content_type: updated some text, name: nil, parameters: key: updated some text, value: updated some text, size: 2, url: nil.In field name: Expected type String, found nil.In field url: Expected type String, found nil."
    end

    test "updated returns error when embed config is invalid - `Absinthe.run`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: nil
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: nil
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: nil)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: nil, parameters: key: updated some text, value: updated some text, size: 2, url: nil, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: 2, price_int: 2, priority: 2.In field config: Expected type UpdateConfig, found content_type: updated some text, name: nil, parameters: key: updated some text, value: updated some text, size: 2, url: nil.In field name: Expected type String, found nil.In field url: Expected type String, found nil."
    end

    test "updated returns error when embed parameters is invalid - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: nil, value: nil }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: nil, value: nil, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: 2, price_int: 2, priority: 2.In field config: Expected type UpdateConfig, found content_type: updated some text, name: updated some text, parameters: key: nil, value: nil, size: 2, url: updated some text.In field parameters: Expected type UpdateParameters!, found key: nil, value: nil.In field key: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "updated returns error when embed parameters is invalid - `Absinthe.run`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: nil, value: nil }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: nil)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: nil, value: nil, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: 2, price_int: 2, priority: 2.In field config: Expected type UpdateConfig, found content_type: updated some text, name: updated some text, parameters: key: nil, value: nil, size: 2, url: updated some text.In field parameters: Expected type UpdateParameters!, found key: nil, value: nil.In field key: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "updated returns empty list when uniqueConstraint nameOperator has been taken - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      insert(:operator, config: config, operator_type: operator_type2)
      operator = insert(:operator, config: config, operator_type: operator_type1, name_operator: "some text#2")
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when uniqueConstraint nameOperator has been taken - `Absinthe.run`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      insert(:operator, config: config, operator_type: operator_type2)
      operator = insert(:operator, config: config, operator_type: operator_type1, name_operator: "some text#2")
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated returns empty list when none exist operatorTypeId - `AbsintheHelpers`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      operator_type_id = FlakeId.get()
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type_id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when none exist operatorTypeId - `Absinthe.run`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      operator_type_id = FlakeId.get()
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type_id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated returns error when operatorTypeId is nil - `AbsintheHelpers`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: nil
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: updated some text, value: updated some text, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: nil, phone_code: 063, price_ext: 2, price_int: 2, priority: 2.In field operator_type_id: Expected type String, found nil."
    end

    test "updated returns error when operatorTypeId is nil - `Absinthe.run`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: nil
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: nil)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: updated some text, value: updated some text, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: nil, phone_code: 063, price_ext: 2, price_int: 2, priority: 2.In field operator_type_id: Expected type String, found nil."
    end

    test "updated returns error when validate decimal priceExt - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: "hello"
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: updated some text, value: updated some text, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: hello, price_int: 2, priority: 2.In field price_ext: Expected type Decimal, found hello."
    end

    test "updated returns error when validate decimal priceExt - `Absinthe.run`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: "hello"
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: nil)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: updated some text, value: updated some text, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: hello, price_int: 2, priority: 2.In field price_ext: Expected type Decimal, found hello."
    end

    test "updated returns error when validate decimal priceInt - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: "hello"
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: updated some text, value: updated some text, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: 2, price_int: hello, priority: 2.In field price_int: Expected type Decimal, found hello."
    end

    test "updated returns error when validate decimal priceInt - `Absinthe.run`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: "hello"
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: nil)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: updated some text, value: updated some text, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: 2, price_int: hello, priority: 2.In field price_int: Expected type Decimal, found hello."
    end

    test "updated returns empty list when validations length min 3 for nameOperator - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: \"#{Lorem.characters(2)}\"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when validations length min 3 for nameOperator - `Absinthe.run`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: \"#{Lorem.characters(2)}\"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated returns empty list when validations length max 100 for nameOperator - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: \"#{Lorem.characters(101)}\"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when validations length max 100 for nameOperator - `Absinthe.run`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: \"#{Lorem.characters(101)}\"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated Operator when validations integer min 0 for limitCount - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: #{Faker.random_between(0, 0)}
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated Operator when validations integer min 0 for limitCount - `Absinthe.run`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: #{Faker.random_between(0, 0)}
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated returns empty list when validations integer max 100_000 for limitCount - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: #{Faker.random_between(101_000, 102_000)}
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when validations integer max 100_000 for limitCount - `Absinthe.run`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: #{Faker.random_between(101_000, 102_000)}
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated returns empty list when validations integer min 1 for priority - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: #{Faker.random_between(0, 0)}
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when validations integer min 1 for priority - `Absinthe.run`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: #{Faker.random_between(0, 0)}
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated returns empty list when validations integer max 99 for priority - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: #{Faker.random_between(100, 103)}
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when validations integer max 99 for priority - `Absinthe.run`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: #{Faker.random_between(100, 103)}
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end
  end

  describe "#list" do
    test "returns Operator with empty list - `AbsintheHelpers`" do
      query = """
      {
        listOperator {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limitCount
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator"))

      assert json_response(res, 200)["errors"] == nil
      [] = json_response(res, 200)["data"]["listOperator"]
    end

    test "returns Operator with empty list - `Absinthe.run`", context do
      query = """
      {
        listOperator {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limitCount
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"listOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns Operator with data - `AbsintheHelpers`" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        listOperator {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limit_count
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator"))

      assert json_response(res, 200)["errors"] == nil
      data = json_response(res, 200)["data"]["listOperator"]
      assert hd(data)["id"]            == operator.id
      assert hd(data)["active"]        == operator.active
      assert hd(data)["limit_count"]   == operator.limit_count
      assert hd(data)["name_operator"] == operator.name_operator
      assert hd(data)["phone_code"]    == operator.phone_code
      assert hd(data)["price_ext"]     == Decimal.new(operator.price_ext) |> to_string
      assert hd(data)["price_int"]     == Decimal.new(operator.price_int) |> to_string
      assert hd(data)["priority"]      == operator.priority

      assert hd(data)["config"]["id"]           == config.id
      assert hd(data)["config"]["content_type"] == config.content_type
      assert hd(data)["config"]["name"]         == config.name
      assert hd(data)["config"]["size"]         == config.size
      assert hd(data)["config"]["url"]          == config.url

      assert hd(data)["config"]["parameters"]["id"]    == parameters.id
      assert hd(data)["config"]["parameters"]["key"]   == parameters.key
      assert hd(data)["config"]["parameters"]["value"] == parameters.value

      assert hd(data)["operator_type"]["id"]        == operator.operator_type_id
      assert hd(data)["operator_type"]["id"]        == operator.operator_type.id
      assert hd(data)["operator_type"]["active"]    == operator.operator_type.active
      assert hd(data)["operator_type"]["name_type"] == operator.operator_type.name_type
      assert hd(data)["operator_type"]["priority"]  == operator.operator_type.priority

      assert hd(data)["sms_logs"]|> hd |> Map.get("id")       == sms_logs.id
      assert hd(data)["sms_logs"]|> hd |> Map.get("priority") == sms_logs.priority

      assert hd(data)["sms_logs"]|> hd |> Map.get("statuses")  |> hd |> Map.get("id") == message.status.id
      assert hd(data)["sms_logs"]|> hd |> Map.get("messages")  |> hd |> Map.get("id") == message.id
      assert hd(data)["sms_logs"]|> hd |> Map.get("operators") |> hd |> Map.get("id") == operator.id
    end

    test "returns Operator with data - `Absinthe.run`", context do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        listOperator {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limit_count
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"listOperator" => [data]}}} =
        Absinthe.run(query, Schema, context: context)

      assert data["id"]            == operator.id
      assert data["active"]        == operator.active
      assert data["limit_count"]   == operator.limit_count
      assert data["name_operator"] == operator.name_operator
      assert data["phone_code"]    == operator.phone_code
      assert data["price_ext"]     == Decimal.new(operator.price_ext) |> to_string
      assert data["price_int"]     == Decimal.new(operator.price_int) |> to_string
      assert data["priority"]      == operator.priority

      assert data["config"]["id"]           == config.id
      assert data["config"]["content_type"] == config.content_type
      assert data["config"]["name"]         == config.name
      assert data["config"]["size"]         == config.size
      assert data["config"]["url"]          == config.url

      assert data["config"]["parameters"]["id"]    == parameters.id
      assert data["config"]["parameters"]["key"]   == parameters.key
      assert data["config"]["parameters"]["value"] == parameters.value

      assert data["operator_type"]["id"]        == operator.operator_type_id
      assert data["operator_type"]["id"]        == operator.operator_type.id
      assert data["operator_type"]["active"]    == operator.operator_type.active
      assert data["operator_type"]["name_type"] == operator.operator_type.name_type
      assert data["operator_type"]["priority"]  == operator.operator_type.priority

      assert data["sms_logs"]|> hd |> Map.get("id")       == sms_logs.id
      assert data["sms_logs"]|> hd |> Map.get("priority") == sms_logs.priority

      assert data["sms_logs"]|> hd |> Map.get("statuses")  |> hd |> Map.get("id") == message.status.id
      assert data["sms_logs"]|> hd |> Map.get("messages")  |> hd |> Map.get("id") == message.id
      assert data["sms_logs"]|> hd |> Map.get("operators") |> hd |> Map.get("id") == operator.id
    end
  end

  describe "#show" do
    test "returns specific OperatorId - `AbsintheHelpers`" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showOperator(id: \"#{operator.id}\") {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limit_count
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator"))

      [found] = json_response(res, 200)["data"]["showOperator"]

      assert found["id"]            == operator.id
      assert found["active"]        == operator.active
      assert found["limit_count"]   == operator.limit_count
      assert found["name_operator"] == operator.name_operator
      assert found["phone_code"]    == operator.phone_code
      assert found["price_ext"]     == Decimal.new(operator.price_ext) |> to_string
      assert found["price_int"]     == Decimal.new(operator.price_int) |> to_string
      assert found["priority"]      == operator.priority

      assert found["config"]["id"]           == config.id
      assert found["config"]["content_type"] == config.content_type
      assert found["config"]["name"]         == config.name
      assert found["config"]["size"]         == config.size
      assert found["config"]["url"]          == config.url

      assert found["config"]["parameters"]["id"]    == parameters.id
      assert found["config"]["parameters"]["key"]   == parameters.key
      assert found["config"]["parameters"]["value"] == parameters.value

      assert found["operator_type"]["id"]        == operator.operator_type_id
      assert found["operator_type"]["id"]        == operator.operator_type.id
      assert found["operator_type"]["active"]    == operator.operator_type.active
      assert found["operator_type"]["name_type"] == operator.operator_type.name_type
      assert found["operator_type"]["priority"]  == operator.operator_type.priority

      assert found["sms_logs"]|> hd |> Map.get("id")       == sms_logs.id
      assert found["sms_logs"]|> hd |> Map.get("priority") == sms_logs.priority

      assert found["sms_logs"]|> hd |> Map.get("statuses")  |> hd |> Map.get("id") == message.status.id
      assert found["sms_logs"]|> hd |> Map.get("messages")  |> hd |> Map.get("id") == message.id
      assert found["sms_logs"]|> hd |> Map.get("operators") |> hd |> Map.get("id") == operator.id
    end

    test "returns specific OperatorId - `Absinthe.run`", context do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showOperator(id: \"#{operator.id}\") {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limit_count
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showOperator" => [found]}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]            == operator.id
      assert found["active"]        == operator.active
      assert found["limit_count"]   == operator.limit_count
      assert found["name_operator"] == operator.name_operator
      assert found["phone_code"]    == operator.phone_code
      assert found["price_ext"]     == Decimal.new(operator.price_ext) |> to_string
      assert found["price_int"]     == Decimal.new(operator.price_int) |> to_string
      assert found["priority"]      == operator.priority

      assert found["config"]["id"]           == config.id
      assert found["config"]["content_type"] == config.content_type
      assert found["config"]["name"]         == config.name
      assert found["config"]["size"]         == config.size
      assert found["config"]["url"]          == config.url

      assert found["config"]["parameters"]["id"]    == parameters.id
      assert found["config"]["parameters"]["key"]   == parameters.key
      assert found["config"]["parameters"]["value"] == parameters.value

      assert found["operator_type"]["id"]        == operator.operator_type_id
      assert found["operator_type"]["id"]        == operator.operator_type.id
      assert found["operator_type"]["active"]    == operator.operator_type.active
      assert found["operator_type"]["name_type"] == operator.operator_type.name_type
      assert found["operator_type"]["priority"]  == operator.operator_type.priority

      assert found["sms_logs"]|> hd |> Map.get("id")       == sms_logs.id
      assert found["sms_logs"]|> hd |> Map.get("priority") == sms_logs.priority

      assert found["sms_logs"]|> hd |> Map.get("statuses")  |> hd |> Map.get("id") == message.status.id
      assert found["sms_logs"]|> hd |> Map.get("messages")  |> hd |> Map.get("id") == message.id
      assert found["sms_logs"]|> hd |> Map.get("operators") |> hd |> Map.get("id") == operator.id
    end

    test "returns empty list when Operator does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      query = """
      {
        showOperator(id: \"#{id}\") {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limit_count
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "operator"))

      assert json_response(res, 200)["data"]["showOperator"] == []
    end

    test "returns empty list when Operator does not exist - `Absinthe.run`", context do
      id = FlakeId.get()
      query = """
      {
        showOperator(id: \"#{id}\") {
          id
          active
          config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
          limit_count
          name_operator
          operator_type { id active name_type priority inserted_at updated_at }
          phone_code
          price_ext
          price_int
          priority
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end
  end

  describe "#create" do
    test "created Operator - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [created] = json_response(res, 200)["data"]["createOperator"]

      assert created["active"]        == true
      assert created["limit_count"]   == 1
      assert created["name_operator"] == "some text"
      assert created["phone_code"]    == "063, 093, 096"
      assert created["price_ext"]     == Decimal.new("1") |> to_string
      assert created["price_int"]     == Decimal.new("1") |> to_string
      assert created["priority"]      == 1

      assert created["config"]["content_type"] == "some text"
      assert created["config"]["name"]         == "some text"
      assert created["config"]["size"]         == 1
      assert created["config"]["url"]          == "some text"

      assert created["config"]["parameters"]["key"]   == "some text"
      assert created["config"]["parameters"]["value"] == "some text"

      assert created["operator_type"]["id"]        == operator_type.id
      assert created["operator_type"]["active"]    == operator_type.active
      assert created["operator_type"]["name_type"] == operator_type.name_type
      assert created["operator_type"]["priority"]  == operator_type.priority

      assert created["sms_logs"] == []
    end

    test "created Operator - `Absinthe.run`", context do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => [created]}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["active"]        == true
      assert created["limit_count"]   == 1
      assert created["name_operator"] == "some text"
      assert created["phone_code"]    == "063, 093, 096"
      assert created["price_ext"]     == Decimal.new("1") |> to_string
      assert created["price_int"]     == Decimal.new("1") |> to_string
      assert created["priority"]      == 1

      assert created["config"]["content_type"] == "some text"
      assert created["config"]["name"]         == "some text"
      assert created["config"]["size"]         == 1
      assert created["config"]["url"]          == "some text"

      assert created["config"]["parameters"]["key"]   == "some text"
      assert created["config"]["parameters"]["value"] == "some text"

      assert created["operator_type"]["id"]        == operator_type.id
      assert created["operator_type"]["active"]    == operator_type.active
      assert created["operator_type"]["name_type"] == operator_type.name_type
      assert created["operator_type"]["priority"]  == operator_type.priority

      assert created["sms_logs"] == []
    end

    test "created returns error when missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createOperator(
          active: nil
          config: {
            content_type: "some text"
            name: nil
            parameters: { key: nil, value: nil }
            size: 1
            url: nil
          }
          limit_count: 1
          name_operator: nil
          operator_type_id: nil
          phone_code: "063, 093, 096"
          price_ext: nil
          price_int: nil
          priority: nil
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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

    test "created returns error when missing params - `Absinthe.run`", context do
      query = """
      mutation {
        createOperator(
          active: nil
          config: {
            content_type: "some text"
            name: nil
            parameters: { key: nil, value: nil }
            size: 1
            url: nil
          }
          limit_count: 1
          name_operator: nil
          operator_type_id: nil
          phone_code: "063, 093, 096"
          price_ext: nil
          price_int: nil
          priority: nil
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: context)
      assert hd(error).message |> String.replace("\"", "") == "Argument active has invalid value nil."
    end

    test "created returns error when config invalid - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: nil
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: nil
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument config has invalid value content_type: some text, name: nil, parameters: key: some text, value: some text, size: 1, url: nil.In field name: Expected type String, found nil.In field url: Expected type String, found nil."
    end

    test "created returns error when config invalid - `Absinthe.run", context do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: nil
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: nil
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: context)
      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument config has invalid value content_type: some text, name: nil, parameters: key: some text, value: some text, size: 1, url: nil.In field name: Expected type String, found nil.In field url: Expected type String, found nil."
    end

    test "created returns error when parameters invalid - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: nil, value: nil }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument config has invalid value content_type: some text, name: some text, parameters: key: nil, value: nil, size: 1, url: some text.In field parameters: Expected type UpdateParameters!, found key: nil, value: nil.In field key: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "created returns error when parameters invalid - `Absinthe.run", context do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: nil, value: nil }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: context)
      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument config has invalid value content_type: some text, name: some text, parameters: key: nil, value: nil, size: 1, url: some text.In field parameters: Expected type UpdateParameters!, found key: nil, value: nil.In field key: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "created returns empty list when uniqueConstraint nameOperator has been taken - `AbsintheHelpers`" do
      insert(:operator, name_operator: "some text")
      operator_type = insert(:operator_type, name_type: "some text#2")
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when uniqueConstraint nameOperator has been taken - `Absinthe.run", context do
      insert(:operator, name_operator: "some text")
      operator_type = insert(:operator_type, name_type: "some text#2")
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created returns empty list when none exist operatorTypeId - `AbsintheHelpers`" do
      operator_type_id = FlakeId.get()
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type_id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when none exist operatorTypeId - `Absinthe.run`", context do
      operator_type_id = FlakeId.get()
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type_id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created returns empty list when validations length min 3 for nameOperator - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: \"#{Lorem.characters(2)}\"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when validations length min 3 for nameOperator - `Absinthe.run`", context do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: \"#{Lorem.characters(2)}\"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created returns empty list when validations length max 100 for nameOperator - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: \"#{Lorem.characters(101)}\"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when validations length max 100 for nameOperator - `Absinthe.run`", context do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: \"#{Lorem.characters(101)}\"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created returns empty list when validations length max 100_000 for limitCount - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: #{Faker.random_between(101_000, 102_000)}
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when validations length max 100_000 for limitCount - `Absinthe.run`", context do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: #{Faker.random_between(101_000, 102_000)}
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created returns empty list when validations integer min 1 for priority - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: #{Faker.random_between(0, 0)}
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when validations integer min 1 for priority - `Absinthe.run`", context do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: #{Faker.random_between(0, 0)}
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created returns empty list when validations integer max 99 for priority - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: #{Faker.random_between(100, 101)}
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createOperator"]
    end

    test "created returns empty list when validations integer max 99 for priority - `Absinthe.run`", context do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: 1
          priority: #{Faker.random_between(100, 101)}
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created returns error when validations decimal priceExt - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: "hello"
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("\"", "") ==
      "Argument price_ext has invalid value hello."
    end

    test "created returns error when validations decimal priceExt - `Absinthe.run`", context do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: "hello"
          price_int: 1
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: context)
      assert hd(error).message
      |> String.replace("\"", "")
      "Argument price_ext has invalid value hello."
    end

    test "created returns error when validations decimal priceInt - `AbsintheHelpers`" do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: "hello"
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("\"", "") ==
      "Argument price_int has invalid value hello."
    end

    test "created returns error when validations decimal priceInt - `Absinthe.run`", context do
      operator_type = insert(:operator_type)
      query = """
      mutation {
        createOperator(
          active: true
          config: {
            content_type: "some text"
            name: "some text"
            parameters: { key: "some text", value: "some text" }
            size: 1
            url: "some text"
          }
          limit_count: 1
          name_operator: "some text"
          operator_type_id: \"#{operator_type.id}\"
          phone_code: "063, 093, 096"
          price_ext: 1
          price_int: "hello"
          priority: 1
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: context)
      assert hd(error).message
      |> String.replace("\"", "") ==
      "Argument price_int has invalid value hello."
    end
  end

  describe "#update" do
    test "update specific OperatorId - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [updated] = json_response(res, 200)["data"]["updateOperator"]

      assert updated["id"]            == operator.id
      assert updated["active"]        == false
      assert updated["limit_count"]   == 2
      assert updated["name_operator"] == "updated some text"
      assert updated["phone_code"]    == "063"
      assert updated["price_ext"]     == "2"
      assert updated["price_int"]     == "2"
      assert updated["priority"]      == 2

      assert updated["config"]["id"]           == config.id
      assert updated["config"]["content_type"] == "updated some text"
      assert updated["config"]["name"]         == "updated some text"
      assert updated["config"]["size"]         == 2
      assert updated["config"]["url"]          == "updated some text"

      assert updated["config"]["parameters"]["id"]    == parameters.id
      assert updated["config"]["parameters"]["key"]   == "updated some text"
      assert updated["config"]["parameters"]["value"] == "updated some text"

      assert updated["operator_type"]["id"]        == operator_type2.id
      assert updated["operator_type"]["active"]    == operator_type2.active
      assert updated["operator_type"]["name_type"] == operator_type2.name_type
      assert updated["operator_type"]["priority"]  == operator_type2.priority

      assert updated["sms_logs"]|> hd |> Map.get("id")       == sms_logs.id
      assert updated["sms_logs"]|> hd |> Map.get("priority") == sms_logs.priority

      assert updated["sms_logs"]|> hd |> Map.get("statuses")  |> hd |> Map.get("id") == message.status.id
      assert updated["sms_logs"]|> hd |> Map.get("messages")  |> hd |> Map.get("id") == message.id
      assert updated["sms_logs"]|> hd |> Map.get("operators") |> hd |> Map.get("id") == operator.id
    end

    test "update specific OperatorId - `Absinthe.run`", context do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """

      {:ok, %{data: %{"updateOperator" => [updated]}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]            == operator.id
      assert updated["active"]        == false
      assert updated["limit_count"]   == 2
      assert updated["name_operator"] == "updated some text"
      assert updated["phone_code"]    == "063"
      assert updated["price_ext"]     == "2"
      assert updated["price_int"]     == "2"
      assert updated["priority"]      == 2

      assert updated["config"]["id"]           == config.id
      assert updated["config"]["content_type"] == "updated some text"
      assert updated["config"]["name"]         == "updated some text"
      assert updated["config"]["size"]         == 2
      assert updated["config"]["url"]          == "updated some text"

      assert updated["config"]["parameters"]["id"]    == parameters.id
      assert updated["config"]["parameters"]["key"]   == "updated some text"
      assert updated["config"]["parameters"]["value"] == "updated some text"

      assert updated["operator_type"]["id"]        == operator_type2.id
      assert updated["operator_type"]["active"]    == operator_type2.active
      assert updated["operator_type"]["name_type"] == operator_type2.name_type
      assert updated["operator_type"]["priority"]  == operator_type2.priority

      assert updated["sms_logs"]|> hd |> Map.get("id")       == sms_logs.id
      assert updated["sms_logs"]|> hd |> Map.get("priority") == sms_logs.priority

      assert updated["sms_logs"]|> hd |> Map.get("statuses")  |> hd |> Map.get("id") == message.status.id
      assert updated["sms_logs"]|> hd |> Map.get("messages")  |> hd |> Map.get("id") == message.id
      assert updated["sms_logs"]|> hd |> Map.get("operators") |> hd |> Map.get("id") == operator.id
    end

    test "update specific OperatorId with embed config and parameters - `AbsintheHelpers`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [updated] = json_response(res, 200)["data"]["updateOperator"]

      assert updated["id"]            == operator.id
      assert updated["active"]        == operator.active
      assert updated["limit_count"]   == operator.limit_count
      assert updated["name_operator"] == operator.name_operator
      assert updated["phone_code"]    == operator.phone_code
      assert updated["price_ext"]     == Decimal.new(operator.price_ext) |> to_string
      assert updated["price_int"]     == Decimal.new(operator.price_int) |> to_string
      assert updated["priority"]      == operator.priority

      assert updated["config"]["id"]           == config.id
      assert updated["config"]["content_type"] == "updated some text"
      assert updated["config"]["name"]         == "updated some text"
      assert updated["config"]["size"]         == 2
      assert updated["config"]["url"]          == "updated some text"

      assert updated["config"]["parameters"]["id"]    == parameters.id
      assert updated["config"]["parameters"]["key"]   == "updated some text"
      assert updated["config"]["parameters"]["value"] == "updated some text"

      assert updated["operator_type"]["id"]        == operator.operator_type_id
      assert updated["operator_type"]["id"]        == operator.operator_type.id
      assert updated["operator_type"]["active"]    == operator.operator_type.active
      assert updated["operator_type"]["name_type"] == operator.operator_type.name_type
      assert updated["operator_type"]["priority"]  == operator.operator_type.priority

      assert updated["sms_logs"]|> hd |> Map.get("id")       == sms_logs.id
      assert updated["sms_logs"]|> hd |> Map.get("priority") == sms_logs.priority

      assert updated["sms_logs"]|> hd |> Map.get("statuses")  |> hd |> Map.get("id") == message.status.id
      assert updated["sms_logs"]|> hd |> Map.get("messages")  |> hd |> Map.get("id") == message.id
      assert updated["sms_logs"]|> hd |> Map.get("operators") |> hd |> Map.get("id") == operator.id
    end

    test "update specific OperatorId with embed config and parameters - `Absinthe.run`", context do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => [updated]}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]            == operator.id
      assert updated["active"]        == operator.active
      assert updated["limit_count"]   == operator.limit_count
      assert updated["name_operator"] == operator.name_operator
      assert updated["phone_code"]    == operator.phone_code
      assert updated["price_ext"]     == Decimal.new(operator.price_ext) |> to_string
      assert updated["price_int"]     == Decimal.new(operator.price_int) |> to_string
      assert updated["priority"]      == operator.priority

      assert updated["config"]["id"]           == config.id
      assert updated["config"]["content_type"] == "updated some text"
      assert updated["config"]["name"]         == "updated some text"
      assert updated["config"]["size"]         == 2
      assert updated["config"]["url"]          == "updated some text"

      assert updated["config"]["parameters"]["id"]    == parameters.id
      assert updated["config"]["parameters"]["key"]   == "updated some text"
      assert updated["config"]["parameters"]["value"] == "updated some text"

      assert updated["operator_type"]["id"]        == operator.operator_type_id
      assert updated["operator_type"]["id"]        == operator.operator_type.id
      assert updated["operator_type"]["active"]    == operator.operator_type.active
      assert updated["operator_type"]["name_type"] == operator.operator_type.name_type
      assert updated["operator_type"]["priority"]  == operator.operator_type.priority

      assert updated["sms_logs"]|> hd |> Map.get("id")       == sms_logs.id
      assert updated["sms_logs"]|> hd |> Map.get("priority") == sms_logs.priority

      assert updated["sms_logs"]|> hd |> Map.get("statuses")  |> hd |> Map.get("id") == message.status.id
      assert updated["sms_logs"]|> hd |> Map.get("messages")  |> hd |> Map.get("id") == message.id
      assert updated["sms_logs"]|> hd |> Map.get("operators") |> hd |> Map.get("id") == operator.id
    end

    test "updated nothing change for missing params - `AbsintheHelpers`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [updated] = json_response(res, 200)["data"]["updateOperator"]
      assert updated["id"]            == operator.id
      assert updated["active"]        == operator.active
      assert updated["limit_count"]   == operator.limit_count
      assert updated["name_operator"] == operator.name_operator
      assert updated["phone_code"]    == operator.phone_code
      assert updated["price_ext"]     == Decimal.new(operator.price_ext) |> to_string
      assert updated["price_int"]     == Decimal.new(operator.price_int) |> to_string
      assert updated["priority"]      == operator.priority

      assert updated["config"]["id"]           == config.id
      assert updated["config"]["content_type"] == config.content_type
      assert updated["config"]["name"]         == config.name
      assert updated["config"]["size"]         == config.size
      assert updated["config"]["url"]          == config.url

      assert updated["config"]["parameters"]["id"]    == parameters.id
      assert updated["config"]["parameters"]["key"]   == parameters.key
      assert updated["config"]["parameters"]["value"] == parameters.value

      assert updated["operator_type"]["id"]        == operator.operator_type_id
      assert updated["operator_type"]["id"]        == operator.operator_type.id
      assert updated["operator_type"]["active"]    == operator.operator_type.active
      assert updated["operator_type"]["name_type"] == operator.operator_type.name_type
      assert updated["operator_type"]["priority"]  == operator.operator_type.priority

      assert updated["sms_logs"]|> hd |> Map.get("id")       == sms_logs.id
      assert updated["sms_logs"]|> hd |> Map.get("priority") == sms_logs.priority

      assert updated["sms_logs"]|> hd |> Map.get("statuses")  |> hd |> Map.get("id") == message.status.id
      assert updated["sms_logs"]|> hd |> Map.get("messages")  |> hd |> Map.get("id") == message.id
      assert updated["sms_logs"]|> hd |> Map.get("operators") |> hd |> Map.get("id") == operator.id
    end

    test "updated nothing change for missing params - `Absinthe.run`", context do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => [updated]}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]            == operator.id
      assert updated["active"]        == operator.active
      assert updated["limit_count"]   == operator.limit_count
      assert updated["name_operator"] == operator.name_operator
      assert updated["phone_code"]    == operator.phone_code
      assert updated["price_ext"]     == Decimal.new(operator.price_ext) |> to_string
      assert updated["price_int"]     == Decimal.new(operator.price_int) |> to_string
      assert updated["priority"]      == operator.priority

      assert updated["config"]["id"]           == config.id
      assert updated["config"]["content_type"] == config.content_type
      assert updated["config"]["name"]         == config.name
      assert updated["config"]["size"]         == config.size
      assert updated["config"]["url"]          == config.url

      assert updated["config"]["parameters"]["id"]    == parameters.id
      assert updated["config"]["parameters"]["key"]   == parameters.key
      assert updated["config"]["parameters"]["value"] == parameters.value

      assert updated["operator_type"]["id"]        == operator.operator_type_id
      assert updated["operator_type"]["id"]        == operator.operator_type.id
      assert updated["operator_type"]["active"]    == operator.operator_type.active
      assert updated["operator_type"]["name_type"] == operator.operator_type.name_type
      assert updated["operator_type"]["priority"]  == operator.operator_type.priority

      assert updated["sms_logs"]|> hd |> Map.get("id")       == sms_logs.id
      assert updated["sms_logs"]|> hd |> Map.get("priority") == sms_logs.priority

      assert updated["sms_logs"]|> hd |> Map.get("statuses")  |> hd |> Map.get("id") == message.status.id
      assert updated["sms_logs"]|> hd |> Map.get("messages")  |> hd |> Map.get("id") == message.id
      assert updated["sms_logs"]|> hd |> Map.get("operators") |> hd |> Map.get("id") == operator.id
    end

    test "updated returns error for missing params - `AbsintheHelpers`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: nil
            config: {
              content_type: "updated some text"
              name: nil
              parameters: { key: nil, value: nil }
              size: 2
              url: nil
            }
            limit_count: 2
            name_operator: nil
            operator_type_id: nil
            phone_code: "063"
            price_ext: nil
            price_int: nil
            priority: nil
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: nil, config: content_type: updated some text, name: nil, parameters: key: nil, value: nil, size: 2, url: nil, limit_count: 2, name_operator: nil, operator_type_id: nil, phone_code: 063, price_ext: nil, price_int: nil, priority: nil.In field active: Expected type Boolean, found nil.In field config: Expected type UpdateConfig, found content_type: updated some text, name: nil, parameters: key: nil, value: nil, size: 2, url: nil.In field name: Expected type String, found nil.In field parameters: Expected type UpdateParameters!, found key: nil, value: nil.In field key: Expected type String, found nil.In field value: Expected type String, found nil.In field url: Expected type String, found nil.In field name_operator: Expected type String, found nil.In field operator_type_id: Expected type String, found nil.In field price_ext: Expected type Decimal, found nil.In field price_int: Expected type Decimal, found nil.In field priority: Expected type Int, found nil."
    end

    test "updated returns error for missing params - `Absinthe.run`", context do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: nil
            config: {
              content_type: "updated some text"
              name: nil
              parameters: { key: nil, value: nil }
              size: 2
              url: nil
            }
            limit_count: 2
            name_operator: nil
            operator_type_id: nil
            phone_code: "063"
            price_ext: nil
            price_int: nil
            priority: nil
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: context)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: nil, config: content_type: updated some text, name: nil, parameters: key: nil, value: nil, size: 2, url: nil, limit_count: 2, name_operator: nil, operator_type_id: nil, phone_code: 063, price_ext: nil, price_int: nil, priority: nil.In field active: Expected type Boolean, found nil.In field config: Expected type UpdateConfig, found content_type: updated some text, name: nil, parameters: key: nil, value: nil, size: 2, url: nil.In field name: Expected type String, found nil.In field parameters: Expected type UpdateParameters!, found key: nil, value: nil.In field key: Expected type String, found nil.In field value: Expected type String, found nil.In field url: Expected type String, found nil.In field name_operator: Expected type String, found nil.In field operator_type_id: Expected type String, found nil.In field price_ext: Expected type Decimal, found nil.In field price_int: Expected type Decimal, found nil.In field priority: Expected type Int, found nil."
    end

    test "updated returns error when embed config is invalid - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: nil
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: nil
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: nil, parameters: key: updated some text, value: updated some text, size: 2, url: nil, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: 2, price_int: 2, priority: 2.In field config: Expected type UpdateConfig, found content_type: updated some text, name: nil, parameters: key: updated some text, value: updated some text, size: 2, url: nil.In field name: Expected type String, found nil.In field url: Expected type String, found nil."
    end

    test "updated returns error when embed config is invalid - `Absinthe.run`", context do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: nil
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: nil
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: context)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: nil, parameters: key: updated some text, value: updated some text, size: 2, url: nil, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: 2, price_int: 2, priority: 2.In field config: Expected type UpdateConfig, found content_type: updated some text, name: nil, parameters: key: updated some text, value: updated some text, size: 2, url: nil.In field name: Expected type String, found nil.In field url: Expected type String, found nil."
    end

    test "updated returns error when embed parameters is invalid - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: nil, value: nil }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: nil, value: nil, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: 2, price_int: 2, priority: 2.In field config: Expected type UpdateConfig, found content_type: updated some text, name: updated some text, parameters: key: nil, value: nil, size: 2, url: updated some text.In field parameters: Expected type UpdateParameters!, found key: nil, value: nil.In field key: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "updated returns error when embed parameters is invalid - `Absinthe.run`", context do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: nil, value: nil }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: context)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: nil, value: nil, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: 2, price_int: 2, priority: 2.In field config: Expected type UpdateConfig, found content_type: updated some text, name: updated some text, parameters: key: nil, value: nil, size: 2, url: updated some text.In field parameters: Expected type UpdateParameters!, found key: nil, value: nil.In field key: Expected type String, found nil.In field value: Expected type String, found nil."
    end

    test "updated returns empty list when uniqueConstraint nameOperator has been taken - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      insert(:operator, config: config, operator_type: operator_type2)
      operator = insert(:operator, config: config, operator_type: operator_type1, name_operator: "some text#2")
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when uniqueConstraint nameOperator has been taken - `Absinthe.run`", context do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      insert(:operator, config: config, operator_type: operator_type2)
      operator = insert(:operator, config: config, operator_type: operator_type1, name_operator: "some text#2")
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated returns empty list when none exist operatorTypeId - `AbsintheHelpers`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      operator_type_id = FlakeId.get()
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type_id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when none exist operatorTypeId - `Absinthe.run`", context do
      operator_type = insert(:operator_type, name_type: "some text#2")
      operator_type_id = FlakeId.get()
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type_id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated returns error when operatorTypeId is nil - `AbsintheHelpers`" do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: nil
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: updated some text, value: updated some text, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: nil, phone_code: 063, price_ext: 2, price_int: 2, priority: 2.In field operator_type_id: Expected type String, found nil."
    end

    test "updated returns error when operatorTypeId is nil - `Absinthe.run`", context do
      operator_type = insert(:operator_type, name_type: "some text#2")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: nil
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: context)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: updated some text, value: updated some text, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: nil, phone_code: 063, price_ext: 2, price_int: 2, priority: 2.In field operator_type_id: Expected type String, found nil."
    end

    test "updated returns error when validate decimal priceExt - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: "hello"
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: updated some text, value: updated some text, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: hello, price_int: 2, priority: 2.In field price_ext: Expected type Decimal, found hello."
    end

    test "updated returns error when validate decimal priceExt - `Absinthe.run`", context do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: "hello"
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: context)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: updated some text, value: updated some text, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: hello, price_int: 2, priority: 2.In field price_ext: Expected type Decimal, found hello."
    end

    test "updated returns error when validate decimal priceInt - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: "hello"
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
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
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: updated some text, value: updated some text, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: 2, price_int: hello, priority: 2.In field price_int: Expected type Decimal, found hello."
    end

    test "updated returns error when validate decimal priceInt - `Absinthe.run`", context do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: "hello"
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} = Absinthe.run(query, Schema, context: context)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") ==
      "Argument operator has invalid value active: false, config: content_type: updated some text, name: updated some text, parameters: key: updated some text, value: updated some text, size: 2, url: updated some text, limit_count: 2, name_operator: updated some text, operator_type_id: #{operator_type2.id}, phone_code: 063, price_ext: 2, price_int: hello, priority: 2.In field price_int: Expected type Decimal, found hello."
    end

    test "updated returns empty list when validations length min 3 for nameOperator - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: \"#{Lorem.characters(2)}\"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when validations length min 3 for nameOperator - `Absinthe.run`", context do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: \"#{Lorem.characters(2)}\"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated returns empty list when validations length max 100 for nameOperator - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: \"#{Lorem.characters(101)}\"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when validations length max 100 for nameOperator - `Absinthe.run`", context do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: \"#{Lorem.characters(101)}\"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated Operator when validations integer min 0 for limitCount - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: #{Faker.random_between(0, 0)}
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [updated] = json_response(res, 200)["data"]["updateOperator"]

      assert updated["id"]            == operator.id
      assert updated["active"]        == false
      assert updated["limit_count"]   == 0
      assert updated["name_operator"] == "updated some text"
      assert updated["phone_code"]    == "063"
      assert updated["price_ext"]     == "2"
      assert updated["price_int"]     == "2"
      assert updated["priority"]      == 2

      assert updated["config"]["id"]           == config.id
      assert updated["config"]["content_type"] == "updated some text"
      assert updated["config"]["name"]         == "updated some text"
      assert updated["config"]["size"]         == 2
      assert updated["config"]["url"]          == "updated some text"

      assert updated["config"]["parameters"]["id"]    == parameters.id
      assert updated["config"]["parameters"]["key"]   == "updated some text"
      assert updated["config"]["parameters"]["value"] == "updated some text"

      assert updated["operator_type"]["id"]        == operator_type2.id
      assert updated["operator_type"]["active"]    == operator_type2.active
      assert updated["operator_type"]["name_type"] == operator_type2.name_type
      assert updated["operator_type"]["priority"]  == operator_type2.priority

      assert updated["sms_logs"]|> hd |> Map.get("id")       == sms_logs.id
      assert updated["sms_logs"]|> hd |> Map.get("priority") == sms_logs.priority

      assert updated["sms_logs"]|> hd |> Map.get("statuses")  |> hd |> Map.get("id") == message.status.id
      assert updated["sms_logs"]|> hd |> Map.get("messages")  |> hd |> Map.get("id") == message.id
      assert updated["sms_logs"]|> hd |> Map.get("operators") |> hd |> Map.get("id") == operator.id
    end

    test "updated Operator when validations integer min 0 for limitCount - `Absinthe.run`", context do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: #{Faker.random_between(0, 0)}
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => [updated]}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]            == operator.id
      assert updated["active"]        == false
      assert updated["limit_count"]   == 0
      assert updated["name_operator"] == "updated some text"
      assert updated["phone_code"]    == "063"
      assert updated["price_ext"]     == "2"
      assert updated["price_int"]     == "2"
      assert updated["priority"]      == 2

      assert updated["config"]["id"]           == config.id
      assert updated["config"]["content_type"] == "updated some text"
      assert updated["config"]["name"]         == "updated some text"
      assert updated["config"]["size"]         == 2
      assert updated["config"]["url"]          == "updated some text"

      assert updated["config"]["parameters"]["id"]    == parameters.id
      assert updated["config"]["parameters"]["key"]   == "updated some text"
      assert updated["config"]["parameters"]["value"] == "updated some text"

      assert updated["operator_type"]["id"]        == operator_type2.id
      assert updated["operator_type"]["active"]    == operator_type2.active
      assert updated["operator_type"]["name_type"] == operator_type2.name_type
      assert updated["operator_type"]["priority"]  == operator_type2.priority

      assert updated["sms_logs"]|> hd |> Map.get("id")       == sms_logs.id
      assert updated["sms_logs"]|> hd |> Map.get("priority") == sms_logs.priority

      assert updated["sms_logs"]|> hd |> Map.get("statuses")  |> hd |> Map.get("id") == message.status.id
      assert updated["sms_logs"]|> hd |> Map.get("messages")  |> hd |> Map.get("id") == message.id
      assert updated["sms_logs"]|> hd |> Map.get("operators") |> hd |> Map.get("id") == operator.id
    end

    test "updated returns empty list when validations integer max 100_000 for limitCount - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: #{Faker.random_between(101_000, 102_000)}
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when validations integer max 100_000 for limitCount - `Absinthe.run`", context do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: #{Faker.random_between(101_000, 102_000)}
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: 2
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated returns empty list when validations integer min 1 for priority - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: #{Faker.random_between(0, 0)}
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when validations integer min 1 for priority - `Absinthe.run`", context do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: #{Faker.random_between(0, 0)}
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated returns empty list when validations integer max 99 for priority - `AbsintheHelpers`" do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: #{Faker.random_between(100, 103)}
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateOperator"]
    end

    test "updated returns empty list when validations integer max 99 for priority - `Absinthe.run`", context do
      operator_type1 = insert(:operator_type, name_type: "some text#2")
      operator_type2 = insert(:operator_type, name_type: "some text#3")
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      message = insert(:message)
      operator = insert(:operator, config: config, operator_type: operator_type1)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      mutation {
        updateOperator(
          id: \"#{operator.id}\",
          operator: {
            active: false
            config: {
              content_type: "updated some text"
              name: "updated some text"
              parameters: { key: "updated some text", value: "updated some text" }
              size: 2
              url: "updated some text"
            }
            limit_count: 2
            name_operator: "updated some text"
            operator_type_id: \"#{operator_type2.id}\"
            phone_code: "063"
            price_ext: 2
            price_int: 2
            priority: #{Faker.random_between(100, 103)}
          }
        ) {
            id
            active
            config { id content_type name parameters { id key value inserted_at updated_at } size url inserted_at updated_at }
            limit_count
            name_operator
            operator_type { id active name_type priority inserted_at updated_at }
            phone_code
            price_ext
            price_int
            priority
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"updateOperator" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end
  end
end
