defmodule Core.Seeder.Deleted.Logs do
  @moduledoc """
  Deleted are seeds whole Logs.
  """

  #alias Core.Repo
  #alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_sms_log()
  end

  @spec deleted_sms_log() :: Ecto.Schema.t()
  defp deleted_sms_log do
    #SQL.query!(Repo, "TRUNCATE sms_logs CASCADE;")
    IO.puts("Deleting data on model's SmsLog\n")
  end
end
