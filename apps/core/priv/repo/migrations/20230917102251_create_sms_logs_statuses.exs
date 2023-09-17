defmodule Core.Repo.Migrations.CreateSmsLogsStatuses do
  use Ecto.Migration

  def change do
    create table(:sms_logs_statuses, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :sms_log_id, references(:sms_logs, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :status_id, references(:statuses, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
    end

    create index(:sms_logs_statuses, [:sms_log_id, :status_id])
    create(unique_index(:sms_logs_statuses, [:sms_log_id, :status_id], name: :sms_log_id_status_id_unique_index))
  end
end
