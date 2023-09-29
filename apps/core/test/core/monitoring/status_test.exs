defmodule Core.Monitoring.StatusTest do
  use Core.DataCase

  describe "Status" do
    alias Core.{
      Logs,
      Monitoring,
      Monitoring.Status,
      Repo
    }

    alias Faker.Lorem

    @valid_attrs %{
      active: true,
      description: "some text",
      status_code: 1,
      status_name: "status #1"
    }

    @invalid_attrs %{
      active: nil,
      status_name: nil,
      status_code: nil
    }

    @relations [
      Core.Monitoring.Status,
      Core.Spring.Message
    ]

    test "list_status/0 with empty list" do
      data = Monitoring.list_status()
      assert data == []
      assert Enum.empty?(data) == true
    end

    test "list_status/0 with data" do
      status = insert(:status)
      data =
        Monitoring.list_status()
      assert data == [status]
      assert Enum.count(data) == 1
    end

    test "create_status/1" do
      assert {:ok, %Status{} = created} = Monitoring.create_status(@valid_attrs)
      assert created.active      == @valid_attrs.active
      assert created.description == @valid_attrs.description
      assert created.status_code == @valid_attrs.status_code
      assert created.status_name == @valid_attrs.status_name
    end

    test "create_status/1 with validations boolean for active" do
      insert(:status)
      attrs = Map.merge(@valid_attrs, %{active: Map.new})
      assert {:error, %Ecto.Changeset{}} = Monitoring.create_status(attrs)
    end

    test "create_status/1 with validations length min 3 for description" do
      insert(:status)
      attrs = Map.merge(@valid_attrs, %{description: Lorem.characters(2)})
      assert {:error, %Ecto.Changeset{}} = Monitoring.create_status(attrs)
    end

    test "create_status/1 with validations length max 100 for description" do
      insert(:status)
      attrs = Map.merge(@valid_attrs, %{description: Lorem.characters(101)})
      assert {:error, %Ecto.Changeset{}} = Monitoring.create_status(attrs)
    end

    test "create_status/1 with validations integer min 1 for status_code" do
      insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_code: Faker.random_between(0, 0)})
      assert {:error, %Ecto.Changeset{}} = Monitoring.create_status(attrs)
    end

    test "create_status/1 with validations integer max 200 for status_code" do
      insert(:status)
      attrs = Map.merge(@valid_attrs, %{status_code: Faker.random_between(201, 203)})
      assert {:error, %Ecto.Changeset{}} = Monitoring.create_status(attrs)
    end

    test "create_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monitoring.create_status(@invalid_attrs)
    end

    test "get_status/1" do
      status = insert(:status)
      struct = Monitoring.get_status(status.id)
      assert struct.id          == status.id
      assert struct.active      == status.active
      assert struct.description == status.description
      assert struct.status_code == status.status_code
      assert struct.status_name == status.status_name
    end

    test "get_status/1 with invalid id returns error changeset" do
      status_id = FlakeId.get()
      assert {:error, %Ecto.Changeset{}} = Monitoring.get_status(status_id)
    end

    test "for many_to_many SmsLogs" do
      message = insert(:message)
      operator = insert(:operator)
      sms_log = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      struct = Logs.get_sms_log(sms_log.id)
      assert  List.first(struct.statuses) |> Map.get(:id) == message.status.id
      assert  List.first(struct.messages) |> Map.get(:id) == message.id
      assert List.first(struct.operators) |> Map.get(:id) == operator.id
    end

    for schema <- @relations, association <- schema.__schema__(:associations) do
      test "#{schema} has a valid association for #{association}" do
        assert_valid_relationship(unquote(schema), unquote(association))
      end
    end

    test "for unique_constraint status code has been taken" do
      insert(:status)
      assert {:error, changeset} = Monitoring.create_status(@valid_attrs)
      assert changeset.errors[:status_code] == {
        "has already been taken", [
          constraint: :unique,
          constraint_name: "statuses_status_code_index"
        ]
      }
    end
  end

  defp assert_valid_relationship(schema, association) do
    schema
    |> join(:left, [s], assoc(s, ^association))
    |> where(false)
    |> Repo.all()

    assert true
  rescue
    UndefinedFunctionError ->
      %{queryable: module} = schema.__schema__(:association, association)
      flunk("""
      Schema #{schema} association #{association} is invalid.
      The associated module #{module} does not appear to be an Ecto
      schema. Is #{schema} missing an alias?
      """)
  end
end
