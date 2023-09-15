defmodule Core.Seeder.Deleted.Monitoring do
  @moduledoc """
  Deleted are seeds whole Monitoring.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_status()
  end

  @spec deleted_status() :: Ecto.Schema.t()
  defp deleted_status do
    IO.puts("Deleting data on model's Status\n")
    SQL.query!(Repo, "TRUNCATE statuses CASCADE;")
  end
end
