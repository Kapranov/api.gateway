defmodule Core.Seeder.Deleted.Spring do
  @moduledoc """
  Deleted are seeds whole Spring.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_message()
  end

  @spec deleted_message() :: Ecto.Schema.t()
  defp deleted_message do
    IO.puts("Deleting data on model's Message\n")
    SQL.query!(Repo, "TRUNCATE messages CASCADE;")
  end
end
