defmodule Core.Repo.Migrations.CreateSmsLogsOperators do
  use Ecto.Migration

  def change do
    create table(:sms_logs_operators, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :operator_id, references(:operators, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :sms_log_id, references(:sms_logs, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
    end

    create index(:sms_logs_operators, [:operator_id, :sms_log_id])
    create(unique_index(:sms_logs_operators, [:sms_log_id, :operator_id], name: :sms_log_id_operator_id_unique_index))
  end
end
