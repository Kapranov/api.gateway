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
  Retrurn list of `value` is `price` or `priceext_priceint` or `priority` when `param` equal `calc_priority`

  ## Example

     iex> search_calc_priority()
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
  Retrurn list of `Operators` when `active` is `true`

  ## Example

     iex> search_active(true)
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
  Sort list of `Operators` by `priority` to ASC

  ## Example

      iex> sort_priority([struct])
      [struct]

  """
  @spec sort_priority([Operator.t()]) :: [Operator.t()]
  def sort_priority(structs) do
    structs
    |> Enum.sort_by(&(&1.priority), :asc)
  end

  @doc """
  Sort list of `Operators` by `price_ext` to ASC

  ## Example

      iex> sort_price_ext([struct])
      [struct]

  """
  @spec sort_price_ext([Operator.t()]) :: [Operator.t()]
  def sort_price_ext(structs) do
    structs
    |> Enum.sort_by(&(&1.price_ext), :asc)
  end
end
