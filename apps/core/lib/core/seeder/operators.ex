defmodule Core.Seeder.Operators do
  @moduledoc """
  Seeds for `Core.Operators` context.
  """

  alias Core.{
    Operators,
    Operators.Operator,
    Operators.OperatorType,
    Repo
  }

  alias Ecto.Adapters.SQL
  alias Faker.Lorem

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    SQL.query!(Repo, "TRUNCATE operator_types CASCADE;")
    SQL.query!(Repo, "TRUNCATE operators CASCADE;")
    IO.puts("Deleting old data in Model's OperatorTypes\n")
    IO.puts("Deleting old data in Model's Operators\n")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_operator_type()
    IO.puts("Inserted data in Model's OperatorTypes\n")
    :timer.sleep(9_000)
    seed_operator()
    IO.puts("Inserted data in Model's Operators\n")
  end

  @spec seed_operator_type() :: nil | Ecto.Schema.t()
  defp seed_operator_type do
    case Repo.aggregate(OperatorType, :count, :id) > 0 do
      true -> nil
      false -> insert_operator_type()
    end
  end

  @spec seed_operator() :: nil | Ecto.Schema.t()
  defp seed_operator do
    case Repo.aggregate(Operator, :count, :id) > 0 do
      true -> nil
      false -> insert_operator()
    end
  end

  @spec insert_operator_type() :: {:ok, any()} | {:error, any()}
  defp insert_operator_type do
    [
      Operators.create_operator_type(%{
        active: true,
        name_type: "Дія push",
        priority: 1
      }),
      Operators.create_operator_type(%{
        active: true,
        name_type: "Intertelecom",
        priority: 1
      }),
      Operators.create_operator_type(%{
        active: true,
        name_type: "Київстар SMS",
        priority: 1
      }),
      Operators.create_operator_type(%{
        active: true,
        name_type: "Lifecell SMS",
        priority: 1
      }),
      Operators.create_operator_type(%{
        active: false,
        name_type: "Lifecell IP Telephony",
        priority: 1
      }),
      Operators.create_operator_type(%{
        active: false,
        name_type: "Telegram",
        priority: 1
      }),
      Operators.create_operator_type(%{
        active: false,
        name_type: "Viber",
        priority: 1
      }),
      Operators.create_operator_type(%{
        active: true,
        name_type: "Vodafone SMS",
        priority: 1
      }),
      Operators.create_operator_type(%{
        active: false,
        name_type: "SMTP",
        priority: 1
      })
    ]
  end

  @spec insert_operator() :: {:ok, any()} | {:error, any()}
  defp insert_operator do
    operator_type_ids = Enum.map(Repo.all(OperatorType), &(&1))
    {
      operator_type_dia,
      operator_type_intertelecom,
      operator_type_kyivstar,
      operator_type_lifecell,
      operator_type_telegram,
      operator_type_viber,
      operator_type_vodafone
    } = {
      Enum.at(operator_type_ids, 0),
      Enum.at(operator_type_ids, 1),
      Enum.at(operator_type_ids, 2),
      Enum.at(operator_type_ids, 3),
      Enum.at(operator_type_ids, 5),
      Enum.at(operator_type_ids, 6),
      Enum.at(operator_type_ids, 7)
    }

    config_dia = %{
      content_type: Lorem.word,
      name: "dia",
      size: random_integers(),
      url: Lorem.word,
      parameters: %{
        key: Lorem.word,
        value: Lorem.word
      }
    }

    config_intertelecom = %{
      content_type: Lorem.word,
      name: "intertelecom",
      size: random_integers(),
      url: Lorem.word,
      parameters: %{
        key: Lorem.word,
        value: Lorem.word
      }
    }

    config_kyivstar = %{
      content_type: Lorem.word,
      name: "kyivstar",
      size: random_integers(),
      url: Lorem.word,
      parameters: %{
        key: Lorem.word,
        value: Lorem.word
      }
    }

    config_lifecell = %{
      content_type: Lorem.word,
      name: "lifecell",
      size: random_integers(),
      url: Lorem.word,
      parameters: %{
        key: Lorem.word,
        value: Lorem.word
      }
    }

    config_telegram = %{
      content_type: Lorem.word,
      name: "telegram",
      size: random_integers(),
      url: Lorem.word,
      parameters: %{
        key: Lorem.word,
        value: Lorem.word
      }
    }

    config_viber = %{
      content_type: Lorem.word,
      name: "viber",
      size: random_integers(),
      url: Lorem.word,
      parameters: %{
        key: Lorem.word,
        value: Lorem.word
      }
    }

    config_vodafone = %{
      content_type: Lorem.word,
      name: "vodafone",
      size: random_integers(),
      url: Lorem.word,
      parameters: %{
        key: Lorem.word,
        value: Lorem.word
      }
    }

    [
      Operators.create_operator(%{
        active: false,
        config: config_dia,
        limit_count: 0,
        name_operator: "Дія",
        operator_type_id: operator_type_dia.id,
        price_ext: 0.01,
        price_int: 0.01,
        priority: 5
      }),
      Operators.create_operator(%{
        active: true,
        config: config_intertelecom,
        phone_code: "094",
        limit_count: 10_000,
        name_operator: "Интертелеком",
        operator_type_id: operator_type_intertelecom.id,
        price_ext: 0.10,
        price_int: 0.45,
        priority: 3
      }),
      Operators.create_operator(%{
        active: true,
        config: config_kyivstar,
        phone_code: "039, 067, 068, 096, 097, 098",
        limit_count: 50_000,
        name_operator: "Київстар",
        operator_type_id: operator_type_kyivstar.id,
        price_ext: 0.21,
        price_int: 0.45,
        priority: 2
      }),
      Operators.create_operator(%{
        active: false,
        config: config_lifecell,
        phone_code: "063, 073, 093",
        limit_count: 1,
        name_operator: "Life",
        operator_type_id: operator_type_lifecell.id,
        price_ext: 0.22,
        price_int: 0.50,
        priority: 7
      }),
      Operators.create_operator(%{
        active: false,
        config: config_telegram,
        limit_count: 0,
        name_operator: "Телеграм",
        operator_type_id: operator_type_telegram.id,
        price_ext: 0.01,
        price_int: 0.01,
        priority: 5
      }),
      Operators.create_operator(%{
        active: false,
        config: config_viber,
        limit_count: 0,
        name_operator: "Вайбер",
        operator_type_id: operator_type_viber.id,
        price_ext: 0.01,
        price_int: 0.01,
        priority: 3
      }),
      Operators.create_operator(%{
        active: true,
        config: config_vodafone,
        phone_code: "050, 095",
        limit_count: 10_000,
        name_operator: "Вудафон",
        operator_type_id: operator_type_vodafone.id,
        price_ext: 0.15,
        price_int: 0.55,
        priority: 1
      }),
      Operators.create_operator(%{
        active: true,
        config: config_vodafone,
        phone_code: "066, 099",
        limit_count: 10_000,
        name_operator: "Вудафон Новий",
        operator_type_id: operator_type_vodafone.id,
        price_ext: 0.11,
        price_int: 0.44,
        priority: 3
      })
    ]
  end

  @spec random_boolean() :: boolean()
  def random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

  @spec random_names :: [String.t()]
  def random_names do
    names = [
      "email",
      "gsm",
      "messager"
    ]

    numbers = 1..1
    number = Enum.random(numbers)
    [result] =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end

  @spec random_name_operator :: [String.t()]
  def random_name_operator do
    names = [
      "Intertelecom",
      "Kyievstar",
      "Lifecell",
      "Vodafone"
    ]

    numbers = 1..1
    number = Enum.random(numbers)
    [result] =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end

  @spec random_phone_code :: [String.t()]
  def random_phone_code do
    names = [
      "098,068,067",
      "099,066,064,061,062",
      "095,063"
    ]

    numbers = 1..1
    number = Enum.random(numbers)
    [result] =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end

  @spec random_integers() :: integer()
  def random_integers(n \\ 99) when is_integer(n) do
    Enum.random(1..n)
  end

  @spec random_float() :: float()
  def random_float do
    :rand.uniform() * 100
    |> Float.round(4)
  end
end
