defmodule Core.Queries do
  @moduledoc """
  Ecto queries.
  """

  import Ecto.Query

  alias Core.{
    Operators.Operator,
    Repo,
    Settings.Setting
  }

  @type word() :: String.t()

  @name "calc_priority"
  @val1 "price"
  @val2 "priceext_priceint"
  @val3 "priority"

  @doc """
  Sorted by listOperators to order.

  1. Founds param is `calc_priority` and value by Settings.
  2. Created list of operators when field is `active` equal `true`.
  3. When `calc_priority` is `price` - sorted operators by field's `:price_ext` with `ASC`
  4. When `calc_priority` is `priority` - sorted operators by field's `:priority` with `ASC`
  5. When `calc_priority` is `priceext_priceint` - took phone_number(+380984263462)
     then parsed only phone's code and created list of operators by code and sorted
     `:price_init` with `ASC`, then parsed only is none phone's code and created
     list of operators by none's code and sorted `:price_ext` with `ASC`.
     And created new list of operators from there are two list of operators.

  ## Example.

      iex> Core.Queries.sorted_by_operators("+380984263462")
      []

  """
  @spec sorted_by_operators(String.t()) :: [Operator.t] | []
  def sorted_by_operators(phone_number) do
    case find_value_calc_priority() do
      :none -> []
      value ->
        operators =
          Enum.reduce(Repo.all(Operator), [], fn(x, acc) ->
            case x.active do
              true -> [x | acc]
              false -> acc
            end
          end)
        case value do
          :price ->
            sorted_price_ext =
              operators
              |> Enum.sort_by(&(&1.price_ext), :asc)

            sorted_price_ext
          :priceext_priceint ->
            code = phone_number |> String.slice(3..5)
            code_operators =
              Enum.reduce(operators, [], fn(x, acc) ->
                case String.contains?(x.phone_code, code) do
                  true -> [x | acc]
                  false -> acc
                end
              end)
            code_operators! =
              Enum.reduce(operators, [], fn(x, acc) ->
                case String.contains?(x.phone_code, code) do
                  true -> acc
                  false -> [x | acc]
                end
              end)
            sorted_code_operators = code_operators |> Enum.sort_by(&(&1.price_int), :asc)
            sorted_code_operators! = code_operators! |> Enum.sort_by(&(&1.price_ext), :asc)
            joint_sorted = sorted_code_operators ++ sorted_code_operators!

            joint_sorted
          :priority ->
            sorted_priority =
              operators
              |> Enum.sort_by(&(&1.priority), :asc)

            sorted_priority
        end
    end
  end

  @doc """
  Retrurn list of `value` is `price` or `priceext_priceint`, `priority`
  when `param` equal `calc_priority`.

  ## Example.

     iex> Core.Queries.search_calc_priority()
     []

  """
  @spec search_calc_priority :: [atom()] | []
  def search_calc_priority do
    Repo.all(
      from c in Setting,
      where: c.param == ^@name,
      where: c.value == ^@val1 or c.value == ^@val2 or c.value == ^@val3,
      select: c.value
    )
  end

  @doc """
  Retrurn list of `Operators` when `active` is `true`.

  ## Example.

     iex> Core.Queries.search_active(true)
     []

  """
  @spec search_active(boolean) :: [Operator.t()] | []
  def search_active(term \\ true) do
    Repo.all(
      from c in Operator,
      where: c.active == ^term
    )
  end

  @doc """
  Sort list of `Operators` by `priority` to ASC.

  ## Example.

      iex> Core.Queries.sort_priority([struct])
      [struct]

  """
  @spec sort_priority([Operator.t()]) :: [Operator.t()]
  def sort_priority(structs) do
    structs
    |> Enum.sort_by(&(&1.priority), :asc)
  end

  @doc """
  Sort list of `Operators` by `price_ext` to ASC.

  ## Example.

      iex> Core.Queries.sort_price_ext([struct])
      [struct]

  """
  @spec sort_price_ext([Operator.t()]) :: [Operator.t()]
  def sort_price_ext(structs) do
    structs
    |> Enum.sort_by(&(&1.price_ext), :asc)
  end

  @doc """
  Sort listis of `Operators` by `phone_number`
  when phone_number is valid and invalid.

  ## Example.

      iex> Core.Queries.sort_priceext_priceint("+380984263462")
      []

  """
  @spec sort_priceext_priceint(String.t()) :: [Operator.t()] | []
  def sort_priceext_priceint(phone_number) do
    code = String.slice(phone_number, 3..5)
    structs_valid = Repo.all(
      from c in Operator,
      where: c.active == true,
      where: ilike(fragment("?::text", c.phone_code), ^"%#{code}%"))
        |> Enum.sort_by(&(&1.price_int), :asc)

    structs_invalid = Repo.all(
      from c in Operator,
      where: c.active == true,
      where: not ilike(fragment("?::text", c.phone_code), ^"%#{code}%"))
        |> Enum.sort_by(&(&1.price_int), :asc)

    structs_valid ++ structs_invalid
  end

  @spec find_value_calc_priority() :: atom()
  defp find_value_calc_priority do
    case search_calc_priority() do
      [] -> :none
      [value] -> value
    end
  end
end
