defmodule Core.Seeder.Updated.Operators do
  @moduledoc """
  An update are seeds whole an operators.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_operator_type()
    IO.puts("Updated data on model's OperatorTypes\n")
    update_operator()
    IO.puts("Updated data on model's Operators\n")
  end

  @spec update_operator_type() :: Ecto.Schema.t()
  defp update_operator_type do
    :ok
  end

  @spec update_operator() :: Ecto.Schema.t()
  defp update_operator do
    :ok
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
