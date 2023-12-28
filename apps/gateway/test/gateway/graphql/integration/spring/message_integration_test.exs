defmodule Gateway.GraphQL.Integration.Settings.MessageIntegrationTest do
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
    test "returns specific Message by id - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showMessage(id: \"#{message.id}\") {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "message"))

      [] = json_response(res, 200)["data"]["showMessage"]
    end

    test "returns specific Message by id - `Absinthe.run`" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showMessage(id: \"#{message.id}\") {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when Message does not exist - `AbsintheHelpers`" do
      message_id = FlakeId.get()
      query = """
      {
        showMessage(id: \"#{message_id}\") {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "message"))

      [] = json_response(res, 200)["data"]["showMessage"]
    end

    test "returns empty list when Message does not exist - `Absinthe.run`" do
      message_id = FlakeId.get()
      query = """
      {
        showMessage(id: \"#{message_id}\") {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when sms_logs count is 2 - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })

      query = """
      {
        showMessage(id: \"#{message.id}\") {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "message"))

      [] = json_response(res, 200)["data"]["showMessage"]
    end

    test "returns empty list when sms_logs count is 2 - `Absinthe.run`" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })

      query = """
      {
        showMessage(id: \"#{message.id}\") {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message `createMessageViaMonitor` - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaMonitor(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessageViaMonitor"]
    end

    test "created Message `createMessageViaMonitor` - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaMonitor(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessageViaMonitor" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message `createMessageViaKafka` - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaKafka(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessageViaKafka"]
    end

    test "created Message `createMessageViaKafka` - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaKafka(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessageViaKafka" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message `createMessageViaConnector` - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaConnector(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessageViaConnector"]
    end

    test "created Message `createMessageViaConnector` - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaConnector(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessageViaConnector" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message `createMessageViaMulti` - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaMulti(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessageViaMulti"]
    end

    test "created Message `createMessageViaMulti` - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaMulti(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessageViaMulti" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message `createMessageViaSelected` - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaSelected(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessageViaSelected"]
    end

    test "created Message `createMessageViaSelected` - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaSelected(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessageViaSelected" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created returns error when missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: nil
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: nil
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: nil
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
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
      |> String.replace("\"", "") == "Argument message_body has invalid value nil."
    end

    test "created returns error when missing params - `Absinthe.run`" do
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: nil
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: nil
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: nil
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: nil)

      assert hd(error).message |> String.replace("\"", "") == "Argument message_body has invalid value nil."
    end

    test "created Message with validations phone_number - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+44991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations phone_number - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+44991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message with validations length min 1 for idExternal - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: \"#{Lorem.characters(0)}\"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations length min 1 for idExternal - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: \"#{Lorem.characters(0)}\"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message with validations length max 10 for idExternal - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: \"#{Lorem.characters(11)}\"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations length max 10 for idExternal - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: \"#{Lorem.characters(11)}\"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message with validations length min 10 for idTelegram - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: \"#{Lorem.characters(9)}\"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations length min 10 for idTelegram - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: \"#{Lorem.characters(9)}\"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message with validations length max 11 for idTelegram - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: \"#{Lorem.characters(12)}\"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations length max 11 for idTelegram - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: \"#{Lorem.characters(12)}\"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message with validations length min 5 for messageBody - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: \"#{Lorem.characters(4)}\"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations length min 5 for messageBody - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: \"#{Lorem.characters(4)}\"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message with validations length max 255 for messageBody - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: \"#{Lorem.characters(256)}\"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations length max 255 for messageBody - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: \"#{Lorem.characters(256)}\"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created Message with validations integer min 1_000_000_000 for idTax - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: \"#{Faker.random_between(999_999_999, 999_999_999)}\"
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
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
      |> String.replace("\"", "") == "Argument id_tax has invalid value 999999999."
    end

    test "created Message with validations integer min 1_000_000_000 for idTax - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: \"#{Faker.random_between(999_999_999, 999_999_999)}\"
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: nil)

      assert hd(error).message |> String.replace("\"", "") == "Argument id_tax has invalid value 999999999."
    end

    test "created Message with validations integer max 9_999_999_999 for idTax - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: \"#{Faker.random_between(10_000_000_001, 10_000_000_001)}\"
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
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
      |> String.replace("\"", "") == "Argument id_tax has invalid value 10000000001."
    end

    test "created Message with validations integer max 9_999_999_999 for idTax - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: \"#{Faker.random_between(10_000_000_001, 10_000_000_001)}\"
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: nil)

      assert hd(error).message |> String.replace("\"", "") == "Argument id_tax has invalid value 10000000001."
    end

    test "created returns empty list when none exist statusId - `AbsintheHelpers`" do
      status_id = FlakeId.get()
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status_id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created returns empty list when none exist statusId - `Absinthe.run`" do
      status_id = FlakeId.get()
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status_id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "created returns error format dateTime messageExpiredAt - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: #{Time.utc_now()}
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
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
      |> String.replace("\"", "") != "syntax error before: 6"
    end

    test "created returns error format dateTime messageExpiredAt - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: #{Time.utc_now()}
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: nil)

      assert hd(error).message |> String.replace("\"", "") != "syntax error before: 6"
    end

    test "created returns error when format dateTime statusChangedAt - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: #{Time.utc_now()}
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
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
      |> String.replace("\"", "") != "syntax error before: 6"
    end

    test "created returns error format dateTime statusChangedAt - `Absinthe.run`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: #{Time.utc_now()}
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: nil)

      assert hd(error).message |> String.replace("\"", "") != "syntax error before: 6"
    end

    test "updated specific Message by id - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated specific Message by id - `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: nil
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: nil
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: nil
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
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
      |> String.replace("\n", "") !=
      "Argument message has invalid value id_external: 2, id_tax: 2222222222, id_telegram: update text, message_body: nil, message_expired_at: 2023-11-02 12:06:55.007393Z, phone_number: nil, status_changed_at: 2023-10-31 12:06:55.007443Z, status_id: nil.In field message_body: Expected type String, found nil.In field phone_number: Expected type String, found nil.In field status_id: Expected type String, found nil."
    end

    test "updated returns error for missing params - `Absinthe.run`" do
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: nil
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: nil
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: nil
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: nil)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") !=
      "Argument message has invalid value id_external: 2, id_tax: 2222222222, id_telegram: update text, message_body: nil, message_expired_at: 2023-11-02 12:06:55.007393Z, phone_number: nil, status_changed_at: 2023-10-31 12:06:55.007443Z, status_id: nil.In field message_body: Expected type String, found nil.In field phone_number: Expected type String, found nil.In field status_id: Expected type String, found nil."
    end

    test "updated Message with validations phone_number - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+44991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations phone_number - `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+44991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated Message with validations length min 1 for idExternal - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: \"#{Lorem.characters(0)}\"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations length min 1 for idExternal - `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: \"#{Lorem.characters(0)}\"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated Message with validations length max 10 for idExternal - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: \"#{Lorem.characters(11)}\"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations length max 10 for idExternal - `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: \"#{Lorem.characters(11)}\"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated Message with validations length min 10 for idTelegram - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: \"#{Lorem.characters(9)}\"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations length min 10 for idTelegram - `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: \"#{Lorem.characters(9)}\"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated Message with validations length max 11 for idTelegram - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: \"#{Lorem.characters(12)}\"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations length max 11 for idTelegram - `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: \"#{Lorem.characters(12)}\"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated Message with validations length min 5 for messageBody- `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: \"#{Lorem.characters(4)}\"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations length min 5 for messageBody- `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: \"#{Lorem.characters(4)}\"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated Message with validations length max 255 for messageBody - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: \"#{Lorem.characters(256)}\"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations length max 255 for messageBody - `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: \"#{Lorem.characters(256)}\"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated Message with validations integer min 1_000_000_000 for idTax - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: #{Faker.random_between(999_999_998, 999_999_999)}
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations integer min 1_000_000_000 for idTax - `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: #{Faker.random_between(999_999_998, 999_999_999)}
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated Message with validations integer max 9_999_999_999 for idTax - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: #{Faker.random_between(10_000_000_001, 10_000_000_002)}
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations integer max 9_999_999_999 for idTax - `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: #{Faker.random_between(10_000_000_001, 10_000_000_002)}
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated returns empty list when none exist statusId - `AbsintheHelpers`" do
      status_id = FlakeId.get()
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status_id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated returns empty list when none exist statusId - `Absinthe.run`" do
      status_id = FlakeId.get()
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status_id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "updated returns error when format dateTime messageExpiredAt - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{Time.utc_now()}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
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
      |> String.replace("\n", "") !=
      "Argument message has invalid value id_external: 2, id_tax: 2222222222, id_telegram: update text, message_body: nil, message_expired_at: 2023-11-02 12:06:55.007393Z, phone_number: nil, status_changed_at: 2023-10-31 12:06:55.007443Z, status_id: nil.In field message_body: Expected type String, found nil.In field phone_number: Expected type String, found nil.In field status_id: Expected type String, found nil."
    end

    test "updated returns error when format dateTime messageExpiredAt - `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{Time.utc_now()}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: nil)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") !=
      "Argument message has invalid value id_external: 2, id_tax: 2222222222, id_telegram: update text, message_body: nil, message_expired_at: 2023-11-02 12:06:55.007393Z, phone_number: nil, status_changed_at: 2023-10-31 12:06:55.007443Z, status_id: nil.In field message_body: Expected type String, found nil.In field phone_number: Expected type String, found nil.In field status_id: Expected type String, found nil."
    end

    test "updated returns error when format dateTime statusChangedAt - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{Time.utc_now()}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
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
      |> String.replace("\n", "") !=
      "Argument message has invalid value id_external: 2, id_tax: 2222222222, id_telegram: update text, message_body: nil, message_expired_at: 2023-11-02 12:06:55.007393Z, phone_number: nil, status_changed_at: 2023-10-31 12:06:55.007443Z, status_id: nil.In field message_body: Expected type String, found nil.In field phone_number: Expected type String, found nil.In field status_id: Expected type String, found nil."
    end

    test "updated returns error when format dateTime statusChangedAt - `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{Time.utc_now()}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: nil)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") !=
      "Argument message has invalid value id_external: 2, id_tax: 2222222222, id_telegram: update text, message_body: nil, message_expired_at: 2023-11-02 12:06:55.007393Z, phone_number: nil, status_changed_at: 2023-10-31 12:06:55.007443Z, status_id: nil.In field message_body: Expected type String, found nil.In field phone_number: Expected type String, found nil.In field status_id: Expected type String, found nil."
    end

    test "updated returns empty list when sms_logs count is 2 - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated returns empty list when sms_logs count is 2 - `Absinthe.run`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end
  end

  describe "#show" do
    test "returns specific Message by id - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showMessage(id: \"#{message.id}\") {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "message"))

      [found] = json_response(res, 200)["data"]["showMessage"]

      assert found["id"]           == message.id
      assert found["id_external"]  == message.id_external
      assert found["id_tax"]       == message.id_tax
      assert found["id_telegram"]  == message.id_telegram
      assert found["message_body"] == message.message_body
      assert found["phone_number"] == message.phone_number
      assert found["status_id"]    == message.status_id

      assert remove(found["message_expired_at"]) == convert(message.message_expired_at)
      assert remove(found["status_changed_at"])  == convert(message.status_changed_at)

      assert hd(found["sms_logs"])["id"]       == hd(message.sms_logs).id
      assert hd(found["sms_logs"])["priority"] == hd(message.sms_logs).priority

      assert hd(found["status"])["id"]          == message.status_id
      assert hd(found["status"])["active"]      == message.status.active
      assert hd(found["status"])["description"] == message.status.description
      assert hd(found["status"])["status_code"] == message.status.status_code
      assert hd(found["status"])["status_name"] == message.status.status_name
    end

    test "returns specific Message by id - `Absinthe.run`", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showMessage(id: \"#{message.id}\") {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showMessage" => [found]}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]           == message.id
      assert found["id_external"]  == message.id_external
      assert found["id_tax"]       == message.id_tax
      assert found["id_telegram"]  == message.id_telegram
      assert found["message_body"] == message.message_body
      assert found["phone_number"] == message.phone_number
      assert found["status_id"]    == message.status_id

      assert remove(found["message_expired_at"]) == convert(message.message_expired_at)
      assert remove(found["status_changed_at"])  == convert(message.status_changed_at)

      assert hd(found["sms_logs"])["id"]       == hd(message.sms_logs).id
      assert hd(found["sms_logs"])["priority"] == hd(message.sms_logs).priority

      assert hd(found["status"])["id"]          == message.status_id
      assert hd(found["status"])["active"]      == message.status.active
      assert hd(found["status"])["description"] == message.status.description
      assert hd(found["status"])["status_code"] == message.status.status_code
      assert hd(found["status"])["status_name"] == message.status.status_name
    end

    test "returns empty list when Message does not exist - `AbsintheHelpers`" do
      message_id = FlakeId.get()
      query = """
      {
        showMessage(id: \"#{message_id}\") {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "message"))

      [] = json_response(res, 200)["data"]["showMessage"]
    end

    test "returns empty list when Message does not exist - `Absinthe.run`", context do
      message_id = FlakeId.get()
      query = """
      {
        showMessage(id: \"#{message_id}\") {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when sms_logs count is 2 - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })

      query = """
      {
        showMessage(id: \"#{message.id}\") {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "message"))

      [found] = json_response(res, 200)["data"]["showMessage"]

      assert found["id"]           == message.id
      assert found["id_external"]  == message.id_external
      assert found["id_tax"]       == message.id_tax
      assert found["id_telegram"]  == message.id_telegram
      assert found["message_body"] == message.message_body
      assert found["phone_number"] == message.phone_number
      assert found["status_id"]    == message.status_id

      assert remove(found["message_expired_at"]) == convert(message.message_expired_at)
      assert remove(found["status_changed_at"])  == convert(message.status_changed_at)

      assert hd(found["sms_logs"])["id"]       == hd(message.sms_logs).id
      assert hd(found["sms_logs"])["priority"] == hd(message.sms_logs).priority

      assert hd(found["status"])["id"]          == message.status_id
      assert hd(found["status"])["active"]      == message.status.active
      assert hd(found["status"])["description"] == message.status.description
      assert hd(found["status"])["status_code"] == message.status.status_code
      assert hd(found["status"])["status_name"] == message.status.status_name

      assert found["sms_logs"] |> Enum.count() == 2
    end

    test "returns empty list when sms_logs count is 2 - `Absinthe.run`", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })

      query = """
      {
        showMessage(id: \"#{message.id}\") {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"showMessage" => [found]}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]           == message.id
      assert found["id_external"]  == message.id_external
      assert found["id_tax"]       == message.id_tax
      assert found["id_telegram"]  == message.id_telegram
      assert found["message_body"] == message.message_body
      assert found["phone_number"] == message.phone_number
      assert found["status_id"]    == message.status_id

      assert remove(found["message_expired_at"]) == convert(message.message_expired_at)
      assert remove(found["status_changed_at"])  == convert(message.status_changed_at)

      assert hd(found["sms_logs"])["id"]       == hd(message.sms_logs).id
      assert hd(found["sms_logs"])["priority"] == hd(message.sms_logs).priority

      assert hd(found["status"])["id"]          == message.status_id
      assert hd(found["status"])["active"]      == message.status.active
      assert hd(found["status"])["description"] == message.status.description
      assert hd(found["status"])["status_code"] == message.status.status_code
      assert hd(found["status"])["status_name"] == message.status.status_name

      assert found["sms_logs"] |> Enum.count() == 2
    end
  end

  describe "#create" do
    test "created Message - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [created] = json_response(res, 200)["data"]["createMessage"]

      assert created["id_external"]  == "1"
      assert created["id_tax"]       == 1_111_111_111
      assert created["id_telegram"]  == "length text"
      assert created["message_body"] == "some text"
      assert created["phone_number"] == "+380991111111"
      assert created["status_id"]    == status.id
      assert created["sms_logs"]     == []

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => [created]}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["id_external"]  == "1"
      assert created["id_tax"]       == 1_111_111_111
      assert created["id_telegram"]  == "length text"
      assert created["message_body"] == "some text"
      assert created["phone_number"] == "+380991111111"
      assert created["status_id"]    == status.id
      assert created["sms_logs"]     == []

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message `createMessageViaMonitor` - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaMonitor(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [created] = json_response(res, 200)["data"]["createMessageViaMonitor"]

      assert created["id_external"]  == "1"
      assert created["id_tax"]       == 1_111_111_111
      assert created["id_telegram"]  == "length text"
      assert created["message_body"] == "some text"
      assert created["phone_number"] == "+380991111111"
      assert created["status_id"]    == status.id
      assert created["sms_logs"]     == []

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message `createMessageViaMonitor` - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaMonitor(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessageViaMonitor" => [created]}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["id_external"]  == "1"
      assert created["id_tax"]       == 1_111_111_111
      assert created["id_telegram"]  == "length text"
      assert created["message_body"] == "some text"
      assert created["phone_number"] == "+380991111111"
      assert created["status_id"]    == status.id
      assert created["sms_logs"]     == []

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message `createMessageViaKafka` - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaKafka(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [created] = json_response(res, 200)["data"]["createMessageViaKafka"]

      assert created["id_external"]  == "1"
      assert created["id_tax"]       == 1_111_111_111
      assert created["id_telegram"]  == "length text"
      assert created["message_body"] == "some text"
      assert created["phone_number"] == "+380991111111"
      assert created["status_id"]    == status.id
      assert created["sms_logs"]     == []

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message `createMessageViaKafka` - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaKafka(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessageViaKafka" => [created]}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["id_external"]  == "1"
      assert created["id_tax"]       == 1_111_111_111
      assert created["id_telegram"]  == "length text"
      assert created["message_body"] == "some text"
      assert created["phone_number"] == "+380991111111"
      assert created["status_id"]    == status.id
      assert created["sms_logs"]     == []

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message `createMessageViaConnector` - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaConnector(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [created] = json_response(res, 200)["data"]["createMessageViaConnector"]

      assert created["id_external"]  == "1"
      assert created["id_tax"]       == 1_111_111_111
      assert created["id_telegram"]  == "length text"
      assert created["message_body"] == "some text"
      assert created["phone_number"] == "+380991111111"
      assert created["status_id"]    == status.id
      assert created["sms_logs"]     == []

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message `createMessageViaConnector` - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaConnector(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessageViaConnector" => [created]}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["id_external"]  == "1"
      assert created["id_tax"]       == 1_111_111_111
      assert created["id_telegram"]  == "length text"
      assert created["message_body"] == "some text"
      assert created["phone_number"] == "+380991111111"
      assert created["status_id"]    == status.id
      assert created["sms_logs"]     == []

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message `createMessageViaMulti` - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaMulti(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [created] = json_response(res, 200)["data"]["createMessageViaMulti"]

      assert created["id_external"]          == "1"
      assert created["id_tax"]               == 1_111_111_111
      assert created["id_telegram"]          == "length text"
      assert created["message_body"]         == "some text"
      assert created["phone_number"]         == "+380991111111"
      assert created["status_id"]            == status.id
      assert Enum.count(created["sms_logs"]) == 1

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message `createMessageViaMulti` - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaMulti(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessageViaMulti" => [created]}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["id_external"]          == "1"
      assert created["id_tax"]               == 1_111_111_111
      assert created["id_telegram"]          == "length text"
      assert created["message_body"]         == "some text"
      assert created["phone_number"]         == "+380991111111"
      assert created["status_id"]            == status.id
      assert Enum.count(created["sms_logs"]) == 1

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message `createMessageViaSelected` - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaSelected(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [created] = json_response(res, 200)["data"]["createMessageViaSelected"]

      assert created["id_external"]  == "1"
      assert created["id_tax"]       == 1_111_111_111
      assert created["id_telegram"]  == "length text"
      assert created["message_body"] == "some text"
      assert created["phone_number"] == "+380991111111"
      assert created["status_id"]    == status.id
      assert created["sms_logs"]     == []

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message `createMessageViaSelected` - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessageViaSelected(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessageViaSelected" => [created]}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["id_external"]  == "1"
      assert created["id_tax"]       == 1_111_111_111
      assert created["id_telegram"]  == "length text"
      assert created["message_body"] == "some text"
      assert created["phone_number"] == "+380991111111"
      assert created["status_id"]    == status.id
      assert created["sms_logs"]     == []

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created returns error when missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: nil
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: nil
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: nil
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
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
      |> String.replace("\"", "") == "Argument message_body has invalid value nil."
    end

    test "created returns error when missing params - `Absinthe.run`", context do
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: nil
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: nil
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: nil
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message |> String.replace("\"", "") == "Argument message_body has invalid value nil."
    end

    test "created Message with validations phone_number - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+44991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations phone_number - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+44991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created Message with validations length min 1 for idExternal - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: \"#{Lorem.characters(0)}\"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [created] = json_response(res, 200)["data"]["createMessage"]

      assert created["id_external"]  == nil
      assert created["id_tax"]       == 1_111_111_111
      assert created["id_telegram"]  == "length text"
      assert created["message_body"] == "some text"
      assert created["phone_number"] == "+380991111111"
      assert created["status_id"]    == status.id
      assert created["sms_logs"]     == []

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message with validations length min 1 for idExternal - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: \"#{Lorem.characters(0)}\"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => [created]}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["id_external"]  == nil
      assert created["id_tax"]       == 1_111_111_111
      assert created["id_telegram"]  == "length text"
      assert created["message_body"] == "some text"
      assert created["phone_number"] == "+380991111111"
      assert created["status_id"]    == status.id
      assert created["sms_logs"]     == []

      assert hd(created["status"])["id"]          == status.id
      assert hd(created["status"])["active"]      == status.active
      assert hd(created["status"])["description"] == status.description
      assert hd(created["status"])["status_code"] == status.status_code
      assert hd(created["status"])["status_name"] == status.status_name
    end

    test "created Message with validations length max 10 for idExternal - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: \"#{Lorem.characters(11)}\"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations length max 10 for idExternal - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: \"#{Lorem.characters(11)}\"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created Message with validations length min 10 for idTelegram - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: \"#{Lorem.characters(9)}\"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations length min 10 for idTelegram - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: \"#{Lorem.characters(9)}\"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created Message with validations length max 11 for idTelegram - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: \"#{Lorem.characters(12)}\"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations length max 11 for idTelegram - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: \"#{Lorem.characters(12)}\"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created Message with validations length min 5 for messageBody - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: \"#{Lorem.characters(4)}\"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations length min 5 for messageBody - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: \"#{Lorem.characters(4)}\"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created Message with validations length max 255 for messageBody - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: \"#{Lorem.characters(256)}\"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created Message with validations length max 255 for messageBody - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: \"#{Lorem.characters(256)}\"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created Message with validations integer min 1_000_000_000 for idTax - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: \"#{Faker.random_between(999_999_999, 999_999_999)}\"
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
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
      |> String.replace("\"", "") == "Argument id_tax has invalid value 999999999."
    end

    test "created Message with validations integer min 1_000_000_000 for idTax - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: \"#{Faker.random_between(999_999_999, 999_999_999)}\"
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message |> String.replace("\"", "") == "Argument id_tax has invalid value 999999999."
    end

    test "created Message with validations integer max 9_999_999_999 for idTax - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: \"#{Faker.random_between(10_000_000_001, 10_000_000_001)}\"
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
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
      |> String.replace("\"", "") == "Argument id_tax has invalid value 10000000001."
    end

    test "created Message with validations integer max 9_999_999_999 for idTax - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: \"#{Faker.random_between(10_000_000_001, 10_000_000_001)}\"
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message |> String.replace("\"", "") == "Argument id_tax has invalid value 10000000001."
    end

    test "created returns empty list when none exist statusId - `AbsintheHelpers`" do
      status_id = FlakeId.get()
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status_id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createMessage"]
    end

    test "created returns empty list when none exist statusId - `Absinthe.run`", context do
      status_id = FlakeId.get()
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status_id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{data: %{"createMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "created returns error format dateTime messageExpiredAt - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: #{Time.utc_now()}
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
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
      |> String.replace("\"", "") != "syntax error before: 6"
    end

    test "created returns error format dateTime messageExpiredAt - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: #{Time.utc_now()}
          phone_number: "+380991111111"
          status_changed_at: \"#{random_datetime(+3)}\"
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message |> String.replace("\"", "") != "syntax error before: 6"
    end

    test "created returns error when format dateTime statusChangedAt - `AbsintheHelpers`" do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: #{Time.utc_now()}
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
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
      |> String.replace("\"", "") != "syntax error before: 6"
    end

    test "created returns error format dateTime statusChangedAt - `Absinthe.run`", context do
      status = insert(:status)
      query = """
      mutation {
        createMessage(
          id_external: "1"
          id_tax: 1111111111
          id_telegram: "length text"
          message_body: "some text"
          message_expired_at: \"#{random_datetime(+7)}\"
          phone_number: "+380991111111"
          status_changed_at: #{Time.utc_now()}
          status_id: \"#{status.id}\"
        ) {
            id
            id_external
            id_tax
            id_telegram
            message_body
            message_expired_at
            phone_number
            sms_logs { id priority statuses { id } messages { id } operators { id } }
            status { id active description sms_logs { id } status_code status_name inserted_at }
            status_changed_at
            status_id
            inserted_at
            updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message |> String.replace("\"", "") != "syntax error before: 6"
    end
  end

  describe "#update" do
    test "updated specific Message by id - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [updated] = json_response(res, 200)["data"]["updateMessage"]

      assert updated["id"]           == struct.id
      assert updated["id_external"]  == "2"
      assert updated["id_tax"]       == 2_222_222_222
      assert updated["id_telegram"]  == "update text"
      assert updated["message_body"] == "updated some text"
      assert updated["phone_number"] == "+380991111333"
      assert updated["status_id"]    == status.id
    end

    test "updated specific Message by id - `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => [updated]}}} =
        Absinthe.run(query, Schema, context: context)
      assert updated["id"]           == struct.id
      assert updated["id_external"]  == "2"
      assert updated["id_tax"]       == 2_222_222_222
      assert updated["id_telegram"]  == "update text"
      assert updated["message_body"] == "updated some text"
      assert updated["phone_number"] == "+380991111333"
      assert updated["status_id"]    == status.id
    end

    test "updated returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: nil
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: nil
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: nil
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
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
      |> String.replace("\n", "") !=
      "Argument message has invalid value id_external: 2, id_tax: 2222222222, id_telegram: update text, message_body: nil, message_expired_at: 2023-11-02 12:06:55.007393Z, phone_number: nil, status_changed_at: 2023-10-31 12:06:55.007443Z, status_id: nil.In field message_body: Expected type String, found nil.In field phone_number: Expected type String, found nil.In field status_id: Expected type String, found nil."
    end

    test "updated returns error for missing params - `Absinthe.run`", context do
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: nil
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: nil
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: nil
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") !=
      "Argument message has invalid value id_external: 2, id_tax: 2222222222, id_telegram: update text, message_body: nil, message_expired_at: 2023-11-02 12:06:55.007393Z, phone_number: nil, status_changed_at: 2023-10-31 12:06:55.007443Z, status_id: nil.In field message_body: Expected type String, found nil.In field phone_number: Expected type String, found nil.In field status_id: Expected type String, found nil."
    end

    test "updated Message with validations phone_number - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+44991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations phone_number - `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+44991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated Message with validations length min 1 for idExternal - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: \"#{Lorem.characters(0)}\"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [updated] = json_response(res, 200)["data"]["updateMessage"]

      assert updated["id"]           == struct.id
      assert updated["id_external"]  == nil
      assert updated["id_tax"]       == 2_222_222_222
      assert updated["id_telegram"]  == "update text"
      assert updated["message_body"] == "updated some text"
      assert updated["phone_number"] == "+380991111333"
      assert updated["status_id"]    == status.id
    end

    test "updated Message with validations length min 1 for idExternal - `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: \"#{Lorem.characters(0)}\"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => [updated]}}} =
        Absinthe.run(query, Schema, context: context)
      assert updated["id"]           == struct.id
      assert updated["id_external"]  == nil
      assert updated["id_tax"]       == 2_222_222_222
      assert updated["id_telegram"]  == "update text"
      assert updated["message_body"] == "updated some text"
      assert updated["phone_number"] == "+380991111333"
      assert updated["status_id"]    == status.id
    end

    test "updated Message with validations length max 10 for idExternal - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: \"#{Lorem.characters(11)}\"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations length max 10 for idExternal - `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: \"#{Lorem.characters(11)}\"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated Message with validations length min 10 for idTelegram - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: \"#{Lorem.characters(9)}\"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations length min 10 for idTelegram - `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: \"#{Lorem.characters(9)}\"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated Message with validations length max 11 for idTelegram - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: \"#{Lorem.characters(12)}\"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations length max 11 for idTelegram - `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: \"#{Lorem.characters(12)}\"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated Message with validations length min 5 for messageBody- `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: \"#{Lorem.characters(4)}\"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations length min 5 for messageBody- `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: \"#{Lorem.characters(4)}\"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated Message with validations length max 255 for messageBody - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: \"#{Lorem.characters(256)}\"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations length max 255 for messageBody - `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: \"#{Lorem.characters(256)}\"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated Message with validations integer min 1_000_000_000 for idTax - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: #{Faker.random_between(999_999_998, 999_999_999)}
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations integer min 1_000_000_000 for idTax - `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: #{Faker.random_between(999_999_998, 999_999_999)}
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated Message with validations integer max 9_999_999_999 for idTax - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: #{Faker.random_between(10_000_000_001, 10_000_000_002)}
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated Message with validations integer max 9_999_999_999 for idTax - `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: #{Faker.random_between(10_000_000_001, 10_000_000_002)}
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated returns empty list when none exist statusId - `AbsintheHelpers`" do
      status_id = FlakeId.get()
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status_id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["updateMessage"]
    end

    test "updated returns empty list when none exist statusId - `Absinthe.run`", context do
      status_id = FlakeId.get()
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status_id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "updated returns error when format dateTime messageExpiredAt - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{Time.utc_now()}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
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
      |> String.replace("\n", "") !=
      "Argument message has invalid value id_external: 2, id_tax: 2222222222, id_telegram: update text, message_body: nil, message_expired_at: 2023-11-02 12:06:55.007393Z, phone_number: nil, status_changed_at: 2023-10-31 12:06:55.007443Z, status_id: nil.In field message_body: Expected type String, found nil.In field phone_number: Expected type String, found nil.In field status_id: Expected type String, found nil."
    end

    test "updated returns error when format dateTime messageExpiredAt - `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{Time.utc_now()}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") !=
      "Argument message has invalid value id_external: 2, id_tax: 2222222222, id_telegram: update text, message_body: nil, message_expired_at: 2023-11-02 12:06:55.007393Z, phone_number: nil, status_changed_at: 2023-10-31 12:06:55.007443Z, status_id: nil.In field message_body: Expected type String, found nil.In field phone_number: Expected type String, found nil.In field status_id: Expected type String, found nil."
    end

    test "updated returns error when format dateTime statusChangedAt - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{Time.utc_now()}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
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
      |> String.replace("\n", "") !=
      "Argument message has invalid value id_external: 2, id_tax: 2222222222, id_telegram: update text, message_body: nil, message_expired_at: 2023-11-02 12:06:55.007393Z, phone_number: nil, status_changed_at: 2023-10-31 12:06:55.007443Z, status_id: nil.In field message_body: Expected type String, found nil.In field phone_number: Expected type String, found nil.In field status_id: Expected type String, found nil."
    end

    test "updated returns error when format dateTime statusChangedAt - `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{Time.utc_now()}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message
      |> String.replace("\"", "")
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.replace("\n", "") !=
      "Argument message has invalid value id_external: 2, id_tax: 2222222222, id_telegram: update text, message_body: nil, message_expired_at: 2023-11-02 12:06:55.007393Z, phone_number: nil, status_changed_at: 2023-10-31 12:06:55.007443Z, status_id: nil.In field message_body: Expected type String, found nil.In field phone_number: Expected type String, found nil.In field status_id: Expected type String, found nil."
    end

    test "updated returns empty list when sms_logs count is 2 - `AbsintheHelpers`" do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [updated] = json_response(res, 200)["data"]["updateMessage"]

      assert updated["id"]           == struct.id
      assert updated["id_external"]  == "2"
      assert updated["id_tax"]       == 2_222_222_222
      assert updated["id_telegram"]  == "update text"
      assert updated["message_body"] == "updated some text"
      assert updated["phone_number"] == "+380991111333"
      assert updated["status_id"]    == status.id

      assert updated["sms_logs"] |> Enum.count() == 1
    end

    test "updated returns empty list when sms_logs count is 2 - `Absinthe.run`", context do
      status = insert(:status, status_code: 2, status_name: "status #2")
      struct = insert(:message)
      query = """
      mutation {
        updateMessage(
          id: \"#{struct.id}\"
          message: {
            id_external: "2"
            id_tax: 2222222222
            id_telegram: "update text"
            message_body: "updated some text"
            message_expired_at: \"#{DateTime.utc_now |> DateTime.add(10, :day)}\"
            phone_number: "+380991111333"
            status_changed_at: \"#{DateTime.utc_now |> DateTime.add(8, :day)}\"
            status_id: \"#{status.id}\"
          }
        ) {
          id
          id_external
          id_tax
          id_telegram
          message_body
          message_expired_at
          phone_number
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          status { id active description sms_logs { id } status_code status_name inserted_at }
          status_changed_at
          status_id
          inserted_at
          updated_at
        }
      }
      """
      {:ok, %{data: %{"updateMessage" => [updated]}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]           == struct.id
      assert updated["id_external"]  == "2"
      assert updated["id_tax"]       == 2_222_222_222
      assert updated["id_telegram"]  == "update text"
      assert updated["message_body"] == "updated some text"
      assert updated["phone_number"] == "+380991111333"
      assert updated["status_id"]    == status.id

      assert updated["sms_logs"] |> Enum.count() == 1
    end
  end

  @spec remove(DateTime.t()) :: String.t()
  defp remove(timestamp) do
    timestamp
    |> String.replace("T", " ")
  end

  @spec convert(DateTime.t()) :: String.t()
  defp convert(timestamp) do
    timestamp
    |> to_string
  end

  @spec random_datetime(neg_integer() | pos_integer()) :: DateTime.t()
  defp random_datetime(num) do
    timestamp =
      DateTime.utc_now
      |> DateTime.add(num, :day)

    timestamp
  end
end
