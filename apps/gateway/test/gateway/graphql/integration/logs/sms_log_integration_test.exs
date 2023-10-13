defmodule Gateway.GraphQL.Integration.Logs.SmsLogIntegrationTest do
  use Gateway.ConnCase

  alias Gateway.{
    AbsintheHelpers,
    Endpoint,
    GraphQL.Resolvers.Home.IndexPageResolver,
    GraphQL.Schema
  }

  @phrase Application.compile_env(:gateway, Endpoint)[:phrase]

  setup_all do
    {:ok, token} = IndexPageResolver.token(nil, nil, nil)
    context = %{token: token}
    context
  end

  describe "#unauthorized" do
    test "returns specific SmsLogs by id - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      sms_log = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showSmsLog(id: \"#{sms_log.id}\") {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "sms_log"))

      [] = json_response(res, 200)["data"]["showSmsLog"]
    end

    test "returns specific SmsLogs by id - `Absinthe.run`" do
      message = insert(:message)
      operator = insert(:operator)
      sms_log = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showSmsLog(id: \"#{sms_log.id}\") {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"showSmsLog" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when SmsLogs does not exist - `AbsintheHelpers`" do
      sms_log_id = FlakeId.get
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showSmsLog(id: \"#{sms_log_id}\") {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "sms_log"))

      [] = json_response(res, 200)["data"]["showSmsLog"]
    end

    test "returns empty list when SmsLogs does not exist - `Absinthe.run`" do
      sms_log_id = FlakeId.get
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showSmsLog(id: \"#{sms_log_id}\") {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"showSmsLog" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when SmsLogs is null - `AbsintheHelpers`" do
      query = """
      {
        showSmsLog(id: nil) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "sms_log"))

      assert hd(json_response(res, 200)["errors"])["message"]
      |> String.replace("\"", "") == "Argument id has invalid value nil."
    end

    test "returns empty list when SmsLogs is null - `Absinthe.run`" do
      query = """
      {
        showSmsLog(id: nil) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{errors: errors}} = Absinthe.run(query, Schema, context: nil)
      assert hd(errors).message |> String.replace("\"", "") == "Argument id has invalid value nil."
    end

    test "creates SmsLogs - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: 1
          operator_id: \"#{operator.id}\"
          message_id: \"#{message.id}\"
          status_id: \"#{message.status.id}\"
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSmsLog"]
    end

    test "creates Status - `Absinthe.run`" do
      message = insert(:message)
      operator = insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: 1
          operator_id: \"#{operator.id}\"
          message_id: \"#{message.id}\"
          status_id: \"#{message.status.id}\"
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createSmsLog" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when missing params - `AbsintheHelpers`" do
      insert(:message)
      insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: nil
          operator_id: nil
          message_id: nil
          status_id: nil
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"]
      |> String.replace("\"", "") == "Argument priority has invalid value nil."
    end

    test "returns empty list when missing params - `Absinthe.run`" do
      insert(:message)
      insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: nil
          operator_id: nil
          message_id: nil
          status_id: nil
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{errors: errors}} = Absinthe.run(query, Schema, context: nil)
      assert hd(errors).message |> String.replace("\"", "") == "Argument priority has invalid value nil."
    end

    test "returns empty list when validations integer min 1 for priority - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: #{Faker.random_between(0, 0)}
          operator_id: \"#{operator.id}\"
          message_id: \"#{message.id}\"
          status_id: \"#{message.status.id}\"
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSmsLog"]
    end

    test "returns empty list when validations integer min 1 for priority - `Absinthe.run`" do
      message = insert(:message)
      operator = insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: #{Faker.random_between(0, 0)}
          operator_id: \"#{operator.id}\"
          message_id: \"#{message.id}\"
          status_id: \"#{message.status.id}\"
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createSmsLog" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when validations integer max 99 for priority - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: #{Faker.random_between(100, 103)}
          operator_id: \"#{operator.id}\"
          message_id: \"#{message.id}\"
          status_id: \"#{message.status.id}\"
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSmsLog"]
    end

    test "returns empty list when validations integer max 99 for priority - `Absinthe.run`" do
      message = insert(:message)
      operator = insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: #{Faker.random_between(100, 103)}
          operator_id: \"#{operator.id}\"
          message_id: \"#{message.id}\"
          status_id: \"#{message.status.id}\"
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createSmsLog" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end
  end

  describe "#show" do
    test "returns specific SmsLogs by id - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      sms_log = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showSmsLog(id: \"#{sms_log.id}\") {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "sms_log"))

      [found] = json_response(res, 200)["data"]["showSmsLog"]
      assert found["id"] == sms_log.id
    end

    test "returns specific SmsLogs by id - `Absinthe.run`", context do
      message = insert(:message)
      operator = insert(:operator)
      sms_log = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showSmsLog(id: \"#{sms_log.id}\") {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"showSmsLog" => [found]}}} =
        Absinthe.run(query, Schema, context: context)
      assert found["id"] == sms_log.id
    end

    test "returns empty list when SmsLogs does not exist - `AbsintheHelpers`" do
      sms_log_id = FlakeId.get
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showSmsLog(id: \"#{sms_log_id}\") {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "sms_log"))

      [] = json_response(res, 200)["data"]["showSmsLog"]
    end

    test "returns empty list when SmsLogs does not exist - `Absinthe.run`", context do
      sms_log_id = FlakeId.get
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showSmsLog(id: \"#{sms_log_id}\") {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"showSmsLog" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when SmsLogs is null - `AbsintheHelpers`" do
      query = """
      {
        showSmsLog(id: nil) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "sms_log"))

      assert hd(json_response(res, 200)["errors"])["message"]
      |> String.replace("\"", "") == "Argument id has invalid value nil."
    end

    test "returns empty list when SmsLogs is null - `Absinthe.run`", context do
      query = """
      {
        showSmsLog(id: nil) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{errors: errors}} = Absinthe.run(query, Schema, context: context)
      assert hd(errors).message |> String.replace("\"", "") == "Argument id has invalid value nil."
    end
  end

  describe "#create" do
    test "creates SmsLogs - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: 1
          operator_id: \"#{operator.id}\"
          message_id: \"#{message.id}\"
          status_id: \"#{message.status.id}\"
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [created] = json_response(res, 200)["data"]["createSmsLog"]

      assert created["priority"] == 1
    end

    test "creates Status - `Absinthe.run`", context do
      message = insert(:message)
      operator = insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: 1
          operator_id: \"#{operator.id}\"
          message_id: \"#{message.id}\"
          status_id: \"#{message.status.id}\"
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createSmsLog" => [created]}}} =
        Absinthe.run(query, Schema, context: context)
      assert created["priority"] == 1
    end

    test "returns empty list when missing params - `AbsintheHelpers`" do
      insert(:message)
      insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: nil
          operator_id: nil
          message_id: nil
          status_id: nil
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"]
      |> String.replace("\"", "") == "Argument priority has invalid value nil."
    end

    test "returns empty list when missing params - `Absinthe.run`", context do
      insert(:message)
      insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: nil
          operator_id: nil
          message_id: nil
          status_id: nil
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{errors: errors}} = Absinthe.run(query, Schema, context: context)
      assert hd(errors).message |> String.replace("\"", "") == "Argument priority has invalid value nil."
    end

    test "returns empty list when validations integer min 1 for priority - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: #{Faker.random_between(0, 0)}
          operator_id: \"#{operator.id}\"
          message_id: \"#{message.id}\"
          status_id: \"#{message.status.id}\"
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSmsLog"]
    end

    test "returns empty list when validations integer min 1 for priority - `Absinthe.run`", context do
      message = insert(:message)
      operator = insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: #{Faker.random_between(0, 0)}
          operator_id: \"#{operator.id}\"
          message_id: \"#{message.id}\"
          status_id: \"#{message.status.id}\"
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createSmsLog" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when validations integer max 99 for priority - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: #{Faker.random_between(100, 103)}
          operator_id: \"#{operator.id}\"
          message_id: \"#{message.id}\"
          status_id: \"#{message.status.id}\"
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createSmsLog"]
    end

    test "returns empty list when validations integer max 99 for priority - `Absinthe.run`", context do
      message = insert(:message)
      operator = insert(:operator)
      query = """
      mutation {
        createSmsLog(
          priority: #{Faker.random_between(100, 103)}
          operator_id: \"#{operator.id}\"
          message_id: \"#{message.id}\"
          status_id: \"#{message.status.id}\"
        ) {
          id
          priority
          operators { id }
          messages { id }
          statuses { id }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createSmsLog" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end
  end
end
