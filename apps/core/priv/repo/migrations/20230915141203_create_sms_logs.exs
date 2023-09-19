defmodule Core.Repo.Migrations.CreateSmsLogs do
  use Ecto.Migration

  def change do
    create table(:sms_logs, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :priority, :integer, null: false

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end
  end
end
