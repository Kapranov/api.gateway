defmodule Core.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :id_external, :string, null: true
      add :id_tax, :bigint, null: true
      add :id_telegram, :string, null: true
      add :message_body, :string, null: false
      add :message_expired_at, :utc_datetime_usec, null: true
      add :phone_number, :string, null: false
      add :status_changed_at, :utc_datetime_usec, null: false, default: fragment("NOW()")
      add :status_id, references(:statuses, type: :uuid, on_delete: :delete_all), null: true, primary_key: false

      timestamps(type: :utc_datetime_usec)
    end
  end
end
