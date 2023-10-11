defmodule Gateway.GraphQL.Integration.Monitoring.StatusIntegrationTest do
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
    test "returns listStatus - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        listStatus {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "status"))

      assert json_response(res, 200)["errors"] == nil
      [] = json_response(res, 200)["data"]["listStatus"]
    end

    test "returns listStatus - `Absinthe.run`" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        listStatus {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """

      {:ok, %{data: %{"listStatus" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns specific Status by id - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showStatus(id: \"#{message.status.id}\") {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "status"))

      [] = json_response(res, 200)["data"]["showStatus"]
    end

    test "returns specific Status by id - `Absinthe.run`" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showStatus(id: \"#{message.status.id}\") {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """

      {:ok, %{data: %{"showStatus" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when Status does not exist - `AbsintheHelpers`" do
      status_id = FlakeId.get
      query = """
      {
        showStatus(id: \"#{status_id}\") {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "status"))

      [] = json_response(res, 200)["data"]["showStatus"]
    end

    test "returns empty list when Status does not exist - `Absinthe.run`" do
      status_id = FlakeId.get
      query = """
      {
        showStatus(id: \"#{status_id}\") {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """

      {:ok, %{data: %{"showStatus" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when Status is null - `AbsintheHelpers`" do
      query = """
      {
        showStatus(id: nil) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "status"))

      [
        %{
          "locations" => [
            %{
              "column" => 14,
              "line" => 2
            }
          ],
          "message" => "Argument \"id\" has invalid value nil."
        }
      ] = json_response(res, 200)["errors"]
    end

    test "returns empty list when Status is null - `Absinthe.run`" do
      query = """
      {
        showStatus(id: nil) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """

      {:ok, %{errors: [
            %{
              message: "Argument \"id\" has invalid value nil.",
              locations: [
                %{
                  line: 2, column: 14
                }
              ]
            }
          ]
        }
      } = Absinthe.run(query, Schema, context: nil)
    end

    test "creates Status - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "creates Status - `Absinthe.run`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: nil
          description: nil
          status_code: nil
          status_name: nil
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [
        %{
          "locations" => [
            %{
              "column" => 5, "line" => 3
            }
          ],
          "message" => "Argument \"active\" has invalid value nil."
        },
        %{
          "locations" => [
            %{
              "column" => 5, "line" => 4
            }
          ],
          "message" => "Argument \"description\" has invalid value nil."
        },
        %{
          "locations" => [
            %{
              "column" => 5, "line" => 5
            }
          ],
          "message" => "Argument \"status_code\" has invalid value nil."
        },
        %{
          "locations" => [
            %{
              "column" => 5, "line" => 6
            }
          ],
          "message" => "Argument \"status_name\" has invalid value nil."
        }
      ] = json_response(res, 200)["errors"]
    end

    test "returns empty list when missing params - `Absinthe.run`" do
      query = """
      mutation {
        createStatus(
          active: nil
          description: nil
          status_code: nil
          status_name: nil
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{errors: [
            %{
              message: "Argument \"active\" has invalid value nil.",
              locations: [%{line: 3, column: 5}]
            },
            %{
              message: "Argument \"description\" has invalid value nil.",
              locations: [
                %{
                  line: 4, column: 5
                }
              ]
            },
            %{
              message: "Argument \"status_code\" has invalid value nil.",
              locations: [
                %{
                  line: 5, column: 5
                }
              ]
            },
            %{
              message: "Argument \"status_name\" has invalid value nil.",
              locations: [
                %{
                  line: 6, column: 5
                }
              ]
            }
          ]
        }
      } = Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when statusCode is an uniqueIndex - `AbsintheHelpers`" do
      insert(:status)
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when statusCode is an uniqueIndex - `Absinthe.run`" do
      insert(:status)
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when with validations boolean for active - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: nil
          description: "some text"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [
        %{
          "locations" => [
            %{
              "column" => 5,
              "line" => 3
            }
          ],
          "message" => "Argument \"active\" has invalid value nil."
        }
      ] = json_response(res, 200)["errors"]
    end

    test "returns empty list when with validations boolean for active - `Absinthe.run`" do
      query = """
      mutation {
        createStatus(
          active: nil
          description: "some text"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{errors: [
            %{
              message: "Argument \"active\" has invalid value nil.",
              locations: [
                %{
                  line: 3,
                  column: 5
                }
              ]
            }
          ]
        }
      } = Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when validations length min 3 for description - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: \"#{Lorem.characters(2)}\"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when validations length min 3 for description - `Absinthe.run`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: \"#{Lorem.characters(2)}\"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when validations length max 100 for description - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: \"#{Lorem.characters(101)}\"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when validations length max 100 for description - `Absinthe.run`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: \"#{Lorem.characters(101)}\"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when validations integer min 1 for statusCode - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: #{Faker.random_between(0, 0)}
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when validations integer min 1 for statusCode - `Absinthe.run`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: #{Faker.random_between(0, 0)}
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when validations integer max 200 for statusCode - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: #{Faker.random_between(201, 203)}
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when validations integer max 200 for statusCode - `Absinthe.run`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: #{Faker.random_between(201, 203)}
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when validations string min 3 for statusName - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: \"#{Lorem.characters(2)}\"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when validations string min 3 for statusName - `Absinthe.run`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: \"#{Lorem.characters(2)}\"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end

    test "returns empty list when validations string max 100 for statusName - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: \"#{Lorem.characters(101)}\"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(nil)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when validations string max 100 for statusName - `Absinthe.run`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: \"#{Lorem.characters(101)}\"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: nil)
    end
  end

  describe "#list" do
    test "returns listStatus - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        listStatus {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "status"))

      assert json_response(res, 200)["errors"] == nil
      data = json_response(res, 200)["data"]["listStatus"]
      assert List.first(data)["id"]          == message.status.id
      assert List.first(data)["active"]      == message.status.active
      assert List.first(data)["description"] == message.status.description
      assert List.first(data)["status_code"] == message.status.status_code
      assert List.first(data)["status_name"] == message.status.status_name
    end

    test "returns listStatus - `Absinthe.run`", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        listStatus {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """

      {:ok, %{data: %{"listStatus" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]          == message.status.id
      assert first["active"]      == message.status.active
      assert first["description"] == message.status.description
      assert first["status_code"] == message.status.status_code
      assert first["status_name"] == message.status.status_name
    end
  end

  describe "#show" do
    test "returns specific Status by id - `AbsintheHelpers`" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showStatus(id: \"#{message.status.id}\") {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "status"))

      [found] = json_response(res, 200)["data"]["showStatus"]

      assert found["id"]          == message.status.id
      assert found["description"] == message.status.description
      assert found["status_code"] == message.status.status_code
      assert found["status_name"] == message.status.status_name
    end

    test "returns specific Status by id - `Absinthe.run`", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      query = """
      {
        showStatus(id: \"#{message.status.id}\") {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """

      {:ok, %{data: %{"showStatus" => [found]}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == message.status.id
      assert found["description"] == message.status.description
      assert found["status_code"] == message.status.status_code
      assert found["status_name"] == message.status.status_name
    end

    test "returns empty list when Status does not exist - `AbsintheHelpers`" do
      status_id = FlakeId.get
      query = """
      {
        showStatus(id: \"#{status_id}\") {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "status"))

      [] = json_response(res, 200)["data"]["showStatus"]
    end

    test "returns empty list when Status does not exist - `Absinthe.run`", context do
      status_id = FlakeId.get
      query = """
      {
        showStatus(id: \"#{status_id}\") {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """

      {:ok, %{data: %{"showStatus" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when Status is null - `AbsintheHelpers`" do
      query = """
      {
        showStatus(id: nil) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "status"))

      assert json_response(res, 200)["errors"] == [%{
        "locations" => [%{
          "column" => 14,
          "line" => 2
        }],
        "message" => "Argument \"id\" has invalid value nil."
      }]
    end

    test "returns empty list when Status is null - `Absinthe.run`", context do
      query = """
      {
        showStatus(id: nil) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """

      {:ok, %{errors: [%{
              message: "Argument \"id\" has invalid value nil.",
              locations: [%{line: 2, column: 14}]
            }]}} =
        Absinthe.run(query, Schema, context: context)
    end
  end

  describe "#create" do
    test "creates Status - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [created] = json_response(res, 200)["data"]["createStatus"]

      assert created["active"]      == true
      assert created["description"] == "some text"
      assert created["status_code"] == 1
      assert created["status_name"] == "some text"
    end

    test "creates Status - `Absinthe.run`", context do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => [created]}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["active"]      == true
      assert created["description"] == "some text"
      assert created["status_code"] == 1
      assert created["status_name"] == "some text"
    end

    test "returns empty list when missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: nil
          description: nil
          status_code: nil
          status_name: nil
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [
        %{
          "locations" => [
            %{
              "column" => 5, "line" => 3
            }
          ],
          "message" => "Argument \"active\" has invalid value nil."
        },
        %{
          "locations" => [
            %{
              "column" => 5, "line" => 4
            }
          ],
          "message" => "Argument \"description\" has invalid value nil."
        },
        %{
          "locations" => [
            %{
              "column" => 5, "line" => 5
            }
          ],
          "message" => "Argument \"status_code\" has invalid value nil."
        },
        %{
          "locations" => [
            %{
              "column" => 5, "line" => 6
            }
          ],
          "message" => "Argument \"status_name\" has invalid value nil."
        }
      ] = json_response(res, 200)["errors"]
    end

    test "returns empty list when missing params - `Absinthe.run`", context do
      query = """
      mutation {
        createStatus(
          active: nil
          description: nil
          status_code: nil
          status_name: nil
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{errors: [
            %{
              message: "Argument \"active\" has invalid value nil.",
              locations: [%{line: 3, column: 5}]
            },
            %{
              message: "Argument \"description\" has invalid value nil.",
              locations: [
                %{
                  line: 4, column: 5
                }
              ]
            },
            %{
              message: "Argument \"status_code\" has invalid value nil.",
              locations: [
                %{
                  line: 5, column: 5
                }
              ]
            },
            %{
              message: "Argument \"status_name\" has invalid value nil.",
              locations: [
                %{
                  line: 6, column: 5
                }
              ]
            }
          ]
        }
      } = Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when statusCode is an uniqueIndex - `AbsintheHelpers`" do
      insert(:status)
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when statusCode is an uniqueIndex - `Absinthe.run`", context do
      insert(:status)
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when with validations boolean for active - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: nil
          description: "some text"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [
        %{
          "locations" => [
            %{
              "column" => 5,
              "line" => 3
            }
          ],
          "message" => "Argument \"active\" has invalid value nil."
        }
      ] = json_response(res, 200)["errors"]
    end

    test "returns empty list when with validations boolean for active - `Absinthe.run`", context do
      query = """
      mutation {
        createStatus(
          active: nil
          description: "some text"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{errors: [
            %{
              message: "Argument \"active\" has invalid value nil.",
              locations: [
                %{
                  line: 3,
                  column: 5
                }
              ]
            }
          ]
        }
      } = Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when validations length min 3 for description - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: \"#{Lorem.characters(2)}\"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when validations length min 3 for description - `Absinthe.run`", context do
      query = """
      mutation {
        createStatus(
          active: true
          description: \"#{Lorem.characters(2)}\"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when validations length max 100 for description - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: \"#{Lorem.characters(101)}\"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when validations length max 100 for description - `Absinthe.run`", context do
      query = """
      mutation {
        createStatus(
          active: true
          description: \"#{Lorem.characters(101)}\"
          status_code: 1
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when validations integer min 1 for statusCode - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: #{Faker.random_between(0, 0)}
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when validations integer min 1 for statusCode - `Absinthe.run`", context do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: #{Faker.random_between(0, 0)}
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when validations integer max 200 for statusCode - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: #{Faker.random_between(201, 203)}
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when validations integer max 200 for statusCode - `Absinthe.run`", context do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: #{Faker.random_between(201, 203)}
          status_name: "some text"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when validations string min 3 for statusName - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: \"#{Lorem.characters(2)}\"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when validations string min 3 for statusName - `Absinthe.run`", context do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: \"#{Lorem.characters(2)}\"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end

    test "returns empty list when validations string max 100 for statusName - `AbsintheHelpers`" do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: \"#{Lorem.characters(101)}\"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      [] = json_response(res, 200)["data"]["createStatus"]
    end

    test "returns empty list when validations string max 100 for statusName - `Absinthe.run`", context do
      query = """
      mutation {
        createStatus(
          active: true
          description: "some text"
          status_code: 1
          status_name: \"#{Lorem.characters(101)}\"
        ) {
          id
          active
          description
          status_code
          status_name
          sms_logs { id priority statuses { id } messages { id } operators { id } }
          inserted_at
        }
      }
      """
      {:ok, %{data: %{"createStatus" => []}}} =
        Absinthe.run(query, Schema, context: context)
    end
  end
end
