defmodule Core.Seeder.Logs do
  @moduledoc """
  Seeds for `Core.Logs` context.
  """

  alias Core.{
    Logs.SmsLog,
    Repo
  }

  alias Ecto.Adapters.SQL

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    SQL.query!(Repo, "TRUNCATE sms_logs CASCADE;")
    IO.puts("Deleting old data in Model's SmsLogs\n")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_sms_log()
    IO.puts("Inserted data on model's Logs\n")
  end

  @spec seed_sms_log() :: nil | Ecto.Schema.t()
  defp seed_sms_log do
    case Repo.aggregate(SmsLog, :count, :id) > 0 do
      true -> nil
      false -> insert_sms_log()
    end
  end

  @spec insert_sms_log() :: {:ok, any()} | {:error, any()}
  defp insert_sms_log do
    :ok
  end
end
