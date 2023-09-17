defmodule Core.Repo.Migrations.CreateSmsLogsMessages do
  use Ecto.Migration

  def change do
    create table(:sms_logs_messages, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :message_id, references(:messages, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :sms_log_id, references(:sms_logs, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
    end

    create index(:sms_logs_messages, [:message_id, :sms_log_id])
    create(unique_index(:sms_logs_messages, [:sms_log_id, :message_id], name: :sms_log_id_message_id_unique_index))
  end
end
