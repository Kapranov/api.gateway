defmodule Core.Seeder.Deleted.Operators do
  @moduledoc """
  Deleted are seeds whole an Operators.
  """

  # alias Core.Repo
  # alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_operator_type()
    deleted_operator()
  end

  @spec deleted_operator_type() :: Ecto.Schema.t()
  defp deleted_operator_type do
    # SQL.query!(Repo, "TRUNCATE operator_types CASCADE;")
    IO.puts("Deleting data on model's OperatorTypes\n")
  end

  @spec deleted_operator() :: Ecto.Schema.t()
  defp deleted_operator do
    # SQL.query!(Repo, "TRUNCATE operators CASCADE;")
    IO.puts("Deleting data on model's Operators\n")
  end
end
