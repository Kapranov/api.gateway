defmodule Core.Operators.OperatorTest do
  use Core.DataCase

  describe "Status" do
    alias Core.{
      Operators,
      Operators.Operator
    }

    alias Faker.Lorem

    @valid_attrs %{
      active: true,
      limit_count: 1,
      name_operator: "some text",
      phone_code: "+380991111111",
      price_ext: 1,
      price_int: 1,
      priority: 1
    }

    @update_attrs %{
      active: false,
      limit_count: 2,
      name_operator: "updated some text",
      phone_code: "+380992222222",
      price_ext: 2,
      price_int: 2,
      priority: 2
    }

    @invalid_attrs %{
      active: nil,
      name_operator: nil,
      operator_type_id: nil,
      price_ext: nil,
      price_int: nil,
      priority: nil
    }

    @relations [
      Core.Operators.Operator,
      Core.Operators.OperatorType
    ]

    test "list_operator/0 with empty list" do
      data = Operators.list_operator()
      assert data == []
      assert Enum.empty?(data) == true
    end

    test "list_operator/0 with data" do
      operator_type = insert(:operator_type)
      insert(:operator, operator_type: operator_type)
      data = Operators.list_operator()
      assert Enum.count(data) == 1
    end

    test "create_operator/1" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})

      attrs = Map.merge(@valid_attrs, %{config: data, operator_type_id: operator_type.id })

      assert {:ok, %Operator{} = created} = Operators.create_operator(attrs)
      assert created.active                  == @valid_attrs.active
      assert created.config.content_type     == config.content_type
      assert created.config.name             == config.name
      assert created.config.size             == config.size
      assert created.config.url              == config.url
      assert created.config.parameters.key   == parameters.key
      assert created.config.parameters.value == parameters.value
      assert created.limit_count             == @valid_attrs.limit_count
      assert created.name_operator           == @valid_attrs.name_operator
      assert created.phone_code              == @valid_attrs.phone_code
      assert created.price_ext               == Decimal.new(@valid_attrs.price_ext)
      assert created.price_int               == Decimal.new(@valid_attrs.price_int)
      assert created.priority                == @valid_attrs.priority
    end

    test "create_operator/1 with config invalid data returns error changeset" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config) |> Map.delete(:name) |> Map.delete(:url)
      parameters_attrs = Map.from_struct(parameters)
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      attrs = Map.merge(@valid_attrs, %{config: data, operator_type_id: operator_type.id })
      assert {:error, %Ecto.Changeset{}} = Operators.create_operator(attrs)
    end

    test "create_operator/1 with parameters invalid data returns error changeset" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters) |> Map.delete(:key) |> Map.delete(:value)
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      attrs = Map.merge(@valid_attrs, %{config: data, operator_type_id: operator_type.id })
      assert {:error, %Ecto.Changeset{}} = Operators.create_operator(attrs)
    end

    test "create_operator/1 with validations length min 3 for name_operator" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters) |> Map.delete(:key) |> Map.delete(:value)
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      attrs = Map.merge(@valid_attrs, %{config: data, operator_type_id: operator_type.id })
      new_attrs = Map.merge(attrs, %{name_operator: Lorem.characters(2)})
      assert {:error, %Ecto.Changeset{}} = Operators.create_operator(new_attrs)
    end

    test "create_operator/1 with validations length max 101 for name_operator" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters) |> Map.delete(:key) |> Map.delete(:value)
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      attrs = Map.merge(@valid_attrs, %{config: data, operator_type_id: operator_type.id })
      new_attrs = Map.merge(attrs, %{name_operator: Lorem.characters(101)})
      assert {:error, %Ecto.Changeset{}} = Operators.create_operator(new_attrs)
    end

    test "create_operator/1 with validations integer max 99 for priority" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters) |> Map.delete(:key) |> Map.delete(:value)
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      attrs = Map.merge(@valid_attrs, %{config: data, operator_type_id: operator_type.id })
      new_attrs = Map.merge(attrs, %{priority: Faker.random_between(100, 101)})
      assert {:error, %Ecto.Changeset{}} = Operators.create_operator(new_attrs)
    end

    test "create_operator/1 with validations integer max 101_000 for limit_count" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters) |> Map.delete(:key) |> Map.delete(:value)
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      attrs = Map.merge(@valid_attrs, %{config: data, operator_type_id: operator_type.id })
      new_attrs = Map.merge(attrs, %{limit_count: Faker.random_between(101_000, 102_000)})
      assert {:error, %Ecto.Changeset{}} = Operators.create_operator(new_attrs)
    end

    test "create_operator/1 with validations integer max 0 for price_ext" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters) |> Map.delete(:key) |> Map.delete(:value)
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      attrs = Map.merge(@valid_attrs, %{config: data, operator_type_id: operator_type.id })
      new_attrs = Map.merge(attrs, %{price_ext: Faker.random_between(0, 0)})
      assert {:error, %Ecto.Changeset{}} = Operators.create_operator(new_attrs)
    end

    test "create_operator/1 with validations integer max 0 for price_int" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters) |> Map.delete(:key) |> Map.delete(:value)
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      attrs = Map.merge(@valid_attrs, %{config: data, operator_type_id: operator_type.id })
      new_attrs = Map.merge(attrs, %{price_int: Faker.random_between(0, 0)})
      assert {:error, %Ecto.Changeset{}} = Operators.create_operator(new_attrs)
    end

    test "create_operator/1 with validations name_operator has been taken" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      attrs = Map.merge(@valid_attrs, %{config: data, operator_type_id: operator_type.id })
      assert {:ok, %Operator{} = _created} = Operators.create_operator(attrs)
      assert {:error, changeset} = Operators.create_operator(attrs)
      assert changeset.errors[:name_operator] == {"has already been taken", [
          {:constraint, :unique},
          {:constraint_name, "operators_name_operator_index"}
        ]}
    end

    test "create_operator/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Operators.create_operator(@invalid_attrs)
    end

    test "get_operator/1" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      operator = insert(:operator, config: config)
      struct = Operators.get_operator(operator.id)
      assert struct.id                      == operator.id
      assert struct.active                  == operator.active
      assert struct.limit_count             == operator.limit_count
      assert struct.name_operator           == operator.name_operator
      assert struct.phone_code              == operator.phone_code
      assert struct.price_ext               == operator.price_ext
      assert struct.price_int               == operator.price_int
      assert struct.priority                == operator.priority
      assert struct.config.content_type     == operator.config.content_type
      assert struct.config.name             == operator.config.name
      assert struct.config.size             == operator.config.size
      assert struct.config.url              == operator.config.url
      assert struct.config.parameters.key   == operator.config.parameters.key
      assert struct.config.parameters.value == operator.config.parameters.value
    end

    test "get_operator/1 with invalid id returns error changeset" do
      operator_id = FlakeId.get()
      assert {:error, %Ecto.Changeset{}} = Operators.get_operator(operator_id)
    end

    test "update_operator_type/2" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      operator = insert(:operator, config: config)
      {:ok, struct} = Operators.update_operator(operator, @update_attrs)
      assert struct.id                      == operator.id
      assert struct.active                  == @update_attrs.active
      assert struct.limit_count             == @update_attrs.limit_count
      assert struct.name_operator           == @update_attrs.name_operator
      assert struct.phone_code              == @update_attrs.phone_code
      assert struct.price_ext               == Decimal.new(@update_attrs.price_ext)
      assert struct.price_int               == Decimal.new(@update_attrs.price_int)
      assert struct.priority                == @update_attrs.priority
      assert struct.config.content_type     == operator.config.content_type
      assert struct.config.name             == operator.config.name
      assert struct.config.size             == operator.config.size
      assert struct.config.url              == operator.config.url
      assert struct.config.parameters.key   == operator.config.parameters.key
      assert struct.config.parameters.value == operator.config.parameters.value
    end

    test "update_operator_type/2 with embed config" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      {:ok, struct} = Operators.update_operator(operator, @update_attrs)
      assert struct.id                      == operator.id
      assert struct.active                  == @update_attrs.active
      assert struct.limit_count             == @update_attrs.limit_count
      assert struct.name_operator           == @update_attrs.name_operator
      assert struct.phone_code              == @update_attrs.phone_code
      assert struct.price_ext               == Decimal.new(@update_attrs.price_ext)
      assert struct.price_int               == Decimal.new(@update_attrs.price_int)
      assert struct.priority                == @update_attrs.priority
      assert struct.config.content_type     == updated_config.content_type
      assert struct.config.name             == updated_config.name
      assert struct.config.size             == updated_config.size
      assert struct.config.url              == updated_config.url
      assert struct.config.parameters.key   == updated_config.parameters.key
      assert struct.config.parameters.value == updated_config.parameters.value
    end

    test "update_operator_type/2 with embed config and parameters" do
      parameters = build(:parameters)
      updated_parameters = Map.merge(parameters, %{
        key: "updated some text",
        value: "updated some text"
      })
      config = build(:config, parameters: updated_parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      {:ok, struct} = Operators.update_operator(operator, @update_attrs)
      assert struct.id                      == operator.id
      assert struct.active                  == @update_attrs.active
      assert struct.limit_count             == @update_attrs.limit_count
      assert struct.name_operator           == @update_attrs.name_operator
      assert struct.phone_code              == @update_attrs.phone_code
      assert struct.price_ext               == Decimal.new(@update_attrs.price_ext)
      assert struct.price_int               == Decimal.new(@update_attrs.price_int)
      assert struct.priority                == @update_attrs.priority
      assert struct.config.content_type     == updated_config.content_type
      assert struct.config.name             == updated_config.name
      assert struct.config.size             == updated_config.size
      assert struct.config.url              == updated_config.url
      assert struct.config.parameters.key   == updated_parameters.key
      assert struct.config.parameters.value == updated_parameters.value
    end

    test "update_operator/2 with nil active" do
      parameters = build(:parameters)
      updated_parameters = Map.merge(parameters, %{
        key: "updated some text",
        value: "updated some text"
      })
      config = build(:config, parameters: updated_parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      updated_attrs = Map.merge(@update_attrs, %{active: nil})
      assert {:error, %Ecto.Changeset{}} = Operators.update_operator(operator, updated_attrs)
    end

    test "update_operator/2 with nil name_operator" do
      parameters = build(:parameters)
      updated_parameters = Map.merge(parameters, %{
        key: "updated some text",
        value: "updated some text"
      })
      config = build(:config, parameters: updated_parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      updated_attrs = Map.merge(@update_attrs, %{name_operator: nil})
      assert {:error, %Ecto.Changeset{}} = Operators.update_operator(operator, updated_attrs)
    end

    test "update_operator/2 with nil operator_type_id" do
      parameters = build(:parameters)
      updated_parameters = Map.merge(parameters, %{
        key: "updated some text",
        value: "updated some text"
      })
      config = build(:config, parameters: updated_parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      updated_attrs = Map.merge(@update_attrs, %{operator_type_id: nil})
      assert {:error, %Ecto.Changeset{}} = Operators.update_operator(operator, updated_attrs)
    end

    test "update_operator/2 with nil price_ext" do
      parameters = build(:parameters)
      updated_parameters = Map.merge(parameters, %{
        key: "updated some text",
        value: "updated some text"
      })
      config = build(:config, parameters: updated_parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      updated_attrs = Map.merge(@update_attrs, %{price_ext: nil})
      assert {:error, %Ecto.Changeset{}} = Operators.update_operator(operator, updated_attrs)
    end

    test "update_operator/2 with nil price_int" do
      parameters = build(:parameters)
      updated_parameters = Map.merge(parameters, %{
        key: "updated some text",
        value: "updated some text"
      })
      config = build(:config, parameters: updated_parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      updated_attrs = Map.merge(@update_attrs, %{price_int: nil})
      assert {:error, %Ecto.Changeset{}} = Operators.update_operator(operator, updated_attrs)
    end

    test "update_operator/2 with nil priority" do
      parameters = build(:parameters)
      updated_parameters = Map.merge(parameters, %{
        key: "updated some text",
        value: "updated some text"
      })
      config = build(:config, parameters: updated_parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      updated_attrs = Map.merge(@update_attrs, %{priority: nil})
      assert {:error, %Ecto.Changeset{}} = Operators.update_operator(operator, updated_attrs)
    end

    test "update_operator/2 with validations length min 3 for name_operator" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      update_attrs = Map.merge(@update_attrs, %{name_operator: Lorem.characters(2)})
      assert {:error, _changeset} = Operators.update_operator(operator, update_attrs)
    end

    test "update_operator/2 with validations length max 101 for name_operator" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      update_attrs = Map.merge(@update_attrs, %{name_operator: Lorem.characters(101)})
      assert {:error, _changeset} = Operators.update_operator(operator, update_attrs)
    end

    test "update_operator/2 with validations integer max 99 for priority" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      update_attrs = Map.merge(@update_attrs, %{priority: Faker.random_between(100, 101)})
      assert {:error, _changeset} = Operators.update_operator(operator, update_attrs)
    end

    test "update_operator/2 with validations integer max 101_000 for limit_count" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      update_attrs = Map.merge(@update_attrs, %{limit_count: Faker.random_between(101_000, 102_000)})
      assert {:error, _changeset} = Operators.update_operator(operator, update_attrs)
    end

    test "update_operator/2 with max 0 for price_ext" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      attrs = Map.merge(@update_attrs, %{price_ext: 0})
      assert {:ok, updated} = Operators.update_operator(operator, attrs)
      assert updated.id        == operator.id
      assert updated.price_ext == Decimal.new("0")
    end

    test "update_operator/2 with max 0 for price_int" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      updated_config = Map.merge(config, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text"
      })
      operator = insert(:operator, config: updated_config)
      attrs = Map.merge(@update_attrs, %{price_int: 0})
      assert {:ok, updated} = Operators.update_operator(operator, attrs)
      assert updated.id        == operator.id
      assert updated.price_int == Decimal.new("0")
    end

    test "update_operator/2 with invalid struct returns error changeset" do
      operator = %Operator{}
      assert {:error, %Ecto.Changeset{}} = Operators.update_operator(operator, %{})
    end

    test "change_operator/1" do
      parameters = build(:parameters)
      config = build(:config, parameters: parameters)
      operator = insert(:operator, config: config)
      assert %Ecto.Changeset{} = Operators.change_operator(operator)
    end

    test "change_operator_type/1 with empty struct" do
      assert %Ecto.Changeset{} = Operators.change_operator(%Operator{})
    end

    for schema <- @relations, association <- schema.__schema__(:associations) do
      test "#{schema} has a valid association for #{association}" do
        assert_valid_relationship(unquote(schema), unquote(association))
      end
    end

    test "for unique_constraint :name_operator has been taken" do
      operator_type = insert(:operator_type)
      insert(:operator, operator_type: operator_type)
      attrs = Map.merge(@valid_attrs, %{operator_type_id: operator_type.id})
      assert {:error, changeset} = Operators.create_operator(attrs)
      assert changeset.errors[:name_operator] == {
        "has already been taken",
        [
          constraint: :unique,
          constraint_name: "operators_name_operator_index"
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
