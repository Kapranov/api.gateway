defmodule Core.Repo.Migrations.CreateSmsLogs do
  use Ecto.Migration

  def change do
    create table(:sms_logs, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :inserted_at, :utc_datetime_usec, null: false, default: fragment("NOW()")
      add :priority, :integer, null: false
      add :status_changed_at, :utc_datetime_usec, null: true
    end
  end
end
