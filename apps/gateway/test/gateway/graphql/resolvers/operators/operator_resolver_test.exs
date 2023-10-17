defmodule Gateway.GraphQL.Resolvers.Operators.OperatorResolverTest do
  use Gateway.ConnCase

  alias Gateway.GraphQL.Resolvers.{
    Home.IndexPageResolver,
    Operators.OperatorResolver
  }

  alias Faker.Lorem

  setup_all do
    {:ok, token} = IndexPageResolver.token(nil, nil, nil)
    context = %{context: %{token: token}}
    context
  end

  describe "#unauthorized" do
    test "returns Operator with empty list" do
      {:ok, []} = OperatorResolver.list(nil, nil, nil)
    end

    test "returns Operator with data" do
      insert(:operator)
      {:ok, []} = OperatorResolver.list(nil, nil, nil)
    end

    test "returns specific OperatorId" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      {:ok, []} = OperatorResolver.show(nil, %{id: operator.id}, nil)
    end

    test "returns empty list when Operator does not exist" do
      id = FlakeId.get()
      {:ok, []} = OperatorResolver.show(nil, %{id: id}, nil)
    end

    test "creates Operator" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "created returns empty list when missing params" do
      args = %{
        active: nil,
        name_operator: nil,
        operator_type_id: nil,
        phone_code: nil,
        price_ext: nil,
        price_int: nil,
        priority: nil
      }
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "created returns empty list when config invalid" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config) |> Map.delete(:name) |> Map.delete(:url)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type.id })
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "created returns empty list when parameters invalid" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters) |> Map.delete(:key) |> Map.delete(:value)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type.id })
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "created returns empty list when uniqueConstraint nameOperator has been taken" do
      insert(:operator, name_operator: "some text")
      operator_type = insert(:operator_type, name_type: "some text#2")
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "created returns empty list when none exist operatorTypeId" do
      operator_type_id = FlakeId.get()
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type_id})
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "created returns empty list when validations length min 3 for nameOperator" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, name_operator: Lorem.characters(2), operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "created returns empty list when validations length max 100 for nameOperator" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, name_operator: Lorem.characters(101), operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "created returns empty list when validations length max 100_000 for limitCount" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, limit_count: Faker.random_between(101_000, 102_000), operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "created returns empty list when validations integer min 1 for priority" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, priority: Faker.random_between(0, 0), operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "crated returns empty list when validations integer max 99 for priority" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, priority: Faker.random_between(100, 103), operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "created returns empty list when validations decimal priceExt" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type.id, price_ext: "hello"})
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "created returns empty list when validations decimal priceInt" do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type.id, price_int: "hello"})
      {:ok, []} = OperatorResolver.create(nil, args, nil)
    end

    test "update specific SettingId" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })

      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{
        id: operator.id,
        operator: params
      }
      {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "update specific OperatorId with embed config and parameters" do
      parameters = build(:parameters)
      parameters_struct = Map.from_struct(parameters)
      updated_parameters = Map.merge(parameters_struct, %{
        key: "updated some text",
        value: "updated some text"
      })
      config = build(:config, parameters: updated_parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      config_struct = Map.from_struct(operator.config)
      config = Map.merge(config_struct, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text",
        parameters: updated_parameters
      })
      params = %{
        active: false,
        config: config,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{
        id: operator.id,
        operator: params
      }
      {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated nothing change for missing params" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{}
      args = %{id: operator.id, operator: params}
      {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated returns empty list for missing params" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: nil,
        name_operator: nil,
        operator_type_id: nil,
        price_ext: nil,
        price_int: nil,
        priority: nil
      }
      args = %{id: operator.id, operator: params}
      {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated empty list when embed config is invalid" do
      parameters = build(:parameters)
      parameters_struct = Map.from_struct(parameters)
      updated_parameters = Map.merge(parameters_struct, %{
        key: "updated some text",
        value: "updated some text"
      })
      config = build(:config, parameters: updated_parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      config_struct = Map.from_struct(operator.config)
      config = Map.merge(config_struct, %{
        content_type: "updated some text",
        name: nil,
        size: 2,
        url: nil,
        parameters: updated_parameters
      })
      params = %{
        active: false,
        config: config,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{
        id: operator.id,
        operator: params
      }
      {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated empty list when embed parameters is invalid" do
      parameters = build(:parameters)
      parameters_struct = Map.from_struct(parameters)
      updated_parameters = Map.merge(parameters_struct, %{
        key: nil,
        value: nil
      })
      config = build(:config, parameters: updated_parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      config_struct = Map.from_struct(operator.config)
      config = Map.merge(config_struct, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text",
        parameters: updated_parameters
      })
      params = %{
        active: false,
        config: config,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{
        id: operator.id,
        operator: params
      }
      {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated returns empty list when uniqueConstraint nameOperator has been taken" do
      insert(:operator)
      operator_type = insert(:operator_type, name_type: "some text#2")
      operator = insert(:operator, name_operator: "some text#2", operator_type: operator_type)
      attrs = %{
        active: false,
        limit_count: 2,
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      params = Map.merge(attrs, %{operator_type_id: operator_type.id, name_operator: "some text"})
      args = %{id: operator.id, operator: params}
      {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated returns empty list when none exist operatorTypeId" do
      operator_type = insert(:operator_type, name_type: "some text#3")
      message = insert(:message)
      operator = insert(:operator, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })

      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        operator_type_id: FlakeId.get(),
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{
        id: operator.id,
        operator: params
      }
      {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated returns empty list when operatorTypeId is nil" do
      operator_type = insert(:operator_type, name_type: "some text#3")
      message = insert(:message)
      operator = insert(:operator, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })

      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        operator_type_id: nil,
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{
        id: operator.id,
        operator: params
      }
      {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated returns empty list when validate decimal priceExt" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_int: 2,
        priority: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{price_ext: "hello"})}
      assert {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated returns empty list when validate decimal priceInt" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        priority: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{price_int: "hello"})}
      assert {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated returns empty list when validations length min 3 for nameOperator" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        limit_count: 2,
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{name_operator: Lorem.characters(2)})}
      assert {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated returns empty list when validations length max 100 for nameOperator" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        limit_count: 2,
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{name_operator: Lorem.characters(101)})}
      assert {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated returns empty list when validations length max 100_000 for limitCount" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{limit_count: Faker.random_between(101_000, 102_000)})}
      assert {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated returns empty list when validations integer min 1 for priority" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{priority: Faker.random_between(0, 0)})}
      assert {:ok, []} = OperatorResolver.update(nil, args, nil)
    end

    test "updated returns empty list when validations integer max 99 for priority" do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{priority: Faker.random_between(100, 103)})}
      assert {:ok, []} = OperatorResolver.update(nil, args, nil)
    end
  end

  describe "#list" do
    test "returns Operator with empty list", context do
      {:ok, []} = OperatorResolver.list(nil, nil, context)
    end

    test "returns Operator with data", context do
      insert(:operator)
      {:ok, data} = OperatorResolver.list(nil, nil, context)
      assert length(data) == 1
    end
  end

  describe "#show" do
    test "returns specific OperatorId", context do
      message = insert(:message)
      operator = insert(:operator)
      sms_logs = insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      {:ok, found} = OperatorResolver.show(nil, %{id: operator.id}, context)
      assert found.id               == operator.id
      assert found.active           == operator.active
      assert found.limit_count      == operator.limit_count
      assert found.name_operator    == operator.name_operator
      assert found.config           == operator.config
      assert found.operator_type_id == operator.operator_type_id
      assert found.phone_code       == operator.phone_code
      assert found.price_ext        == operator.price_ext
      assert found.price_int        == operator.price_int
      assert found.priority         == operator.priority
      assert found.inserted_at      == operator.inserted_at
      assert found.updated_at       == operator.updated_at

      assert hd(found.sms_logs).id       == sms_logs.id
      assert hd(found.sms_logs).priority == sms_logs.priority
    end

    test "returns empty list when Operator does not exist", context do
      id = FlakeId.get()
      {:ok, []} = OperatorResolver.show(nil, %{id: id}, context)
    end
  end

  describe "#create" do
    test "creates Operator", context do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type.id})
      {:ok, created} = OperatorResolver.create(nil, args, context)
      assert created.active                  == attrs.active
      assert created.config.content_type     == config.content_type
      assert created.config.name             == config.name
      assert created.config.size             == config.size
      assert created.config.url              == config.url
      assert created.config.parameters.key   == parameters.key
      assert created.config.parameters.value == parameters.value
      assert created.limit_count             == attrs.limit_count
      assert created.name_operator           == attrs.name_operator
      assert created.phone_code              == attrs.phone_code
      assert created.price_ext               == Decimal.new(attrs.price_ext)
      assert created.price_int               == Decimal.new(attrs.price_int)
      assert created.priority                == attrs.priority
    end

    test "created returns empty list when missing params", context do
      args = %{
        active: nil,
        name_operator: nil,
        operator_type_id: nil,
        phone_code: nil,
        price_ext: nil,
        price_int: nil,
        priority: nil
      }
      {:ok, []} = OperatorResolver.create(nil, args, context)
    end

    test "created returns empty list when config invalid", context do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config) |> Map.delete(:name) |> Map.delete(:url)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type.id })
      {:ok, []} = OperatorResolver.create(nil, args, context)
    end

    test "created returns empty list when parameters invalid", context do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters) |> Map.delete(:key) |> Map.delete(:value)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type.id })
      {:ok, []} = OperatorResolver.create(nil, args, context)
    end

    test "created returns empty list when uniqueConstraint nameOperator has been taken", context do
      insert(:operator, name_operator: "some text")
      operator_type = insert(:operator_type, name_type: "some text#2")
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, context)
    end

    test "created returns empty list when none exist operatorTypeId", context do
      operator_type_id = FlakeId.get()
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type_id})
      {:ok, []} = OperatorResolver.create(nil, args, context)
    end

    test "created returns empty list when validations length min 3 for nameOperator", context do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, name_operator: Lorem.characters(2), operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, context)
    end

    test "created returns empty list when validations length max 100 for nameOperator", context do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, name_operator: Lorem.characters(101), operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, context)
    end

    test "created returns empty list when validations length max 100_000 for limitCount", context do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, limit_count: Faker.random_between(101_000, 102_000), operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, context)
    end

    test "created returns empty list when validations integer min 1 for priority", context do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, priority: Faker.random_between(0, 0), operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, context)
    end

    test "crated returns empty list when validations integer max 99 for priority", context do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        price_int: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, priority: Faker.random_between(100, 103), operator_type_id: operator_type.id})
      {:ok, []} = OperatorResolver.create(nil, args, context)
    end

    test "created returns empty list when validations decimal priceExt", context do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_int: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type.id, price_ext: "hello"})
      {:ok, []} = OperatorResolver.create(nil, args, context)
    end

    test "created returns empty list when validations decimal priceInt", context do
      operator_type = insert(:operator_type)
      config = build(:config)
      parameters = build(:parameters)
      config_attrs = Map.from_struct(config)
      parameters_attrs = Map.from_struct(parameters)
      attrs = %{
        active: true,
        limit_count: 1,
        name_operator: "some text",
        phone_code: "063, 093, 096",
        price_ext: 1,
        priority: 1
      }
      data = Map.merge(config_attrs, %{parameters: parameters_attrs})
      args = Map.merge(attrs, %{config: data, operator_type_id: operator_type.id, price_int: "hello"})
      {:ok, []} = OperatorResolver.create(nil, args, context)
    end
  end

  describe "#update" do
    test "update specific SettingId", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })

      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{
        id: operator.id,
        operator: params
      }
      {:ok, updated} = OperatorResolver.update(nil, args, context)
      assert updated.id               == operator.id
      assert updated.active           == params.active
      assert updated.limit_count      == params.limit_count
      assert updated.name_operator    == params.name_operator
      assert updated.config           == operator.config
      assert updated.operator_type_id == operator.operator_type_id
      assert updated.phone_code       == params.phone_code
      assert updated.price_ext        == Decimal.new(params.price_ext)
      assert updated.price_int        == Decimal.new(params.price_int)
      assert updated.priority         == params.priority
      assert updated.inserted_at      == operator.inserted_at
      assert updated.updated_at       != operator.updated_at
    end

    test "update specific OperatorId with embed config and parameters", context do
      parameters = build(:parameters)
      parameters_struct = Map.from_struct(parameters)
      updated_parameters = Map.merge(parameters_struct, %{
        key: "updated some text",
        value: "updated some text"
      })
      config = build(:config, parameters: updated_parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      config_struct = Map.from_struct(operator.config)
      config = Map.merge(config_struct, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text",
        parameters: updated_parameters
      })
      params = %{
        active: false,
        config: config,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{
        id: operator.id,
        operator: params
      }
      {:ok, updated} = OperatorResolver.update(nil, args, context)
      assert updated.id                      == operator.id
      assert updated.active                  == params.active
      assert updated.limit_count             == params.limit_count
      assert updated.name_operator           == params.name_operator
      assert updated.config.content_type     == config.content_type
      assert updated.config.name             == config.name
      assert updated.config.size             == config.size
      assert updated.config.url              == config.url
      assert updated.config.parameters.key   == updated_parameters.key
      assert updated.config.parameters.value == updated_parameters.value
      assert updated.operator_type_id        == operator.operator_type_id
      assert updated.phone_code              == params.phone_code
      assert updated.price_ext               == Decimal.new(params.price_ext)
      assert updated.price_int               == Decimal.new(params.price_int)
      assert updated.priority                == params.priority
      assert updated.inserted_at             == operator.inserted_at
      assert updated.updated_at              != operator.updated_at
    end

    test "updated nothing change for missing params", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{}
      args = %{id: operator.id, operator: params}
      {:ok, updated} = OperatorResolver.update(nil, args, context)
      assert updated.id               == operator.id
      assert updated.active           == operator.active
      assert updated.limit_count      == operator.limit_count
      assert updated.name_operator    == operator.name_operator
      assert updated.config           == operator.config
      assert updated.operator_type_id == operator.operator_type_id
      assert updated.phone_code       == operator.phone_code
      assert updated.price_ext        == operator.price_ext
      assert updated.price_int        == operator.price_int
      assert updated.priority         == operator.priority
      assert updated.inserted_at      == operator.inserted_at
      assert updated.updated_at       == operator.updated_at
    end

    test "updated returns empty list for missing params", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: nil,
        name_operator: nil,
        operator_type_id: nil,
        price_ext: nil,
        price_int: nil,
        priority: nil
      }
      args = %{id: operator.id, operator: params}
      {:ok, []} = OperatorResolver.update(nil, args, context)
    end

    test "updated empty list when embed config is invalid", context do
      parameters = build(:parameters)
      parameters_struct = Map.from_struct(parameters)
      updated_parameters = Map.merge(parameters_struct, %{
        key: "updated some text",
        value: "updated some text"
      })
      config = build(:config, parameters: updated_parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      config_struct = Map.from_struct(operator.config)
      config = Map.merge(config_struct, %{
        content_type: "updated some text",
        name: nil,
        size: 2,
        url: nil,
        parameters: updated_parameters
      })
      params = %{
        active: false,
        config: config,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{
        id: operator.id,
        operator: params
      }
      {:ok, []} = OperatorResolver.update(nil, args, context)
    end

    test "updated empty list when embed parameters is invalid", context do
      parameters = build(:parameters)
      parameters_struct = Map.from_struct(parameters)
      updated_parameters = Map.merge(parameters_struct, %{
        key: nil,
        value: nil
      })
      config = build(:config, parameters: updated_parameters)
      message = insert(:message)
      operator = insert(:operator, config: config)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      config_struct = Map.from_struct(operator.config)
      config = Map.merge(config_struct, %{
        content_type: "updated some text",
        name: "updated some text",
        size: 2,
        url: "updated some text",
        parameters: updated_parameters
      })
      params = %{
        active: false,
        config: config,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{
        id: operator.id,
        operator: params
      }
      {:ok, []} = OperatorResolver.update(nil, args, context)
    end

    test "updated returns empty list when uniqueConstraint nameOperator has been taken", context do
      insert(:operator)
      operator_type = insert(:operator_type, name_type: "some text#2")
      operator = insert(:operator, name_operator: "some text#2", operator_type: operator_type)
      attrs = %{
        active: false,
        limit_count: 2,
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      params = Map.merge(attrs, %{operator_type_id: operator_type.id, name_operator: "some text"})
      args = %{id: operator.id, operator: params}
      {:ok, []} = OperatorResolver.update(nil, args, context)
    end

    test "updated returns empty list when none exist operatorTypeId", context do
      operator_type = insert(:operator_type, name_type: "some text#3")
      message = insert(:message)
      operator = insert(:operator, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })

      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        operator_type_id: FlakeId.get(),
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{
        id: operator.id,
        operator: params
      }
      {:ok, []} = OperatorResolver.update(nil, args, context)
    end

    test "updated returns empty list when operatorTypeId is nil", context do
      operator_type = insert(:operator_type, name_type: "some text#3")
      message = insert(:message)
      operator = insert(:operator, operator_type: operator_type)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })

      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        operator_type_id: nil,
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{
        id: operator.id,
        operator: params
      }
      {:ok, []} = OperatorResolver.update(nil, args, context)
    end

    test "updated returns empty list when validate decimal priceExt", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_int: 2,
        priority: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{price_ext: "hello"})}
      assert {:ok, []} = OperatorResolver.update(nil, args, context)
    end

    test "updated returns empty list when validate decimal priceInt", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        priority: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{price_int: "hello"})}
      assert {:ok, []} = OperatorResolver.update(nil, args, context)
    end

    test "updated returns empty list when validations length min 3 for nameOperator", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        limit_count: 2,
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{name_operator: Lorem.characters(2)})}
      assert {:ok, []} = OperatorResolver.update(nil, args, context)
    end

    test "updated returns empty list when validations length max 100 for nameOperator", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        limit_count: 2,
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{name_operator: Lorem.characters(101)})}
      assert {:ok, []} = OperatorResolver.update(nil, args, context)
    end

    test "updated returns empty list when validations length max 100_000 for limitCount", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2,
        priority: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{limit_count: Faker.random_between(101_000, 102_000)})}
      assert {:ok, []} = OperatorResolver.update(nil, args, context)
    end

    test "updated returns empty list when validations integer min 1 for priority", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{priority: Faker.random_between(0, 0)})}
      assert {:ok, []} = OperatorResolver.update(nil, args, context)
    end

    test "updated returns empty list when validations integer max 99 for priority", context do
      message = insert(:message)
      operator = insert(:operator)
      insert(:sms_log, %{
        operators: [operator],
        messages: [message],
        statuses: [message.status]
      })
      params = %{
        active: false,
        limit_count: 2,
        name_operator: "updated some text",
        phone_code: "063",
        price_ext: 2,
        price_int: 2
      }
      args = %{id: operator.id, operator: Map.merge(params, %{priority: Faker.random_between(100, 103)})}
      assert {:ok, []} = OperatorResolver.update(nil, args, context)
    end
  end
end
