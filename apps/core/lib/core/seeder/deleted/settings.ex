defmodule Core.Seeder.Deleted.Settings do
  @moduledoc """
  Deleted are seeds whole Settings.
  """

  #alias Core.Repo
  #alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_setting()
  end

  @spec deleted_setting() :: Ecto.Schema.t()
  defp deleted_setting do
    #SQL.query!(Repo, "TRUNCATE settings CASCADE;")
    IO.puts("Deleting data on model's Settings\n")
  end
end
