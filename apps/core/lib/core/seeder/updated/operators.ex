defmodule Core.Seeder.Updated.Operators do
  @moduledoc """
  An update are seeds whole an operators.
  """

  alias Core.{
    Operators,
    Operators.OperatorType,
    Repo
  }

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_operator_type()
    IO.puts("Updated data on model's OperatorTypes\n")
    update_operator()
    IO.puts("Updated data on model's Operators\n")
  end

  @spec update_operator_type() :: Ecto.Schema.t()
  defp update_operator_type do
    operator_type1 = Repo.get_by(OperatorType, %{active: true})
    [
      Operators.update_operator_type(operator_type1, %{
        active: random_boolean(),
        name: random_names(),
        priority: random_integers()
      })
    ]
  end

  @spec update_operator() :: Ecto.Schema.t()
  defp update_operator do
    :ok
  end

  @spec random_boolean() :: boolean()
  defp random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

  @spec random_names :: [String.t()]
  defp random_names do
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

  @spec random_integers() :: integer()
  defp random_integers(n \\ 99) when is_integer(n) do
    Enum.random(1..n)
  end
end
