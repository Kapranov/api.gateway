defmodule Core.Seeder.Deleted.Operators do
  @moduledoc """
  Deleted are seeds whole an Operators.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_operator_type()
  end

  @spec deleted_operator_type() :: Ecto.Schema.t()
  defp deleted_operator_type do
    IO.puts("Deleting data on model's OperatorTypes\n")
    SQL.query!(Repo, "TRUNCATE operator_types CASCADE;")
  end
end
