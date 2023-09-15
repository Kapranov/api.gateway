defmodule Core.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :id_external, :string, null: true
      add :id_tax, :string, null: true
      add :id_telegram, :string, null: true
      add :inserted_at, :timestamp, null: false, default: fragment("NOW()")
      add :message_body, :string, null: false
      add :message_expired_at, :date, null: true
      add :phone_number, :string, null: false
      add :status_id, references(:statuses, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
    end
  end
end
