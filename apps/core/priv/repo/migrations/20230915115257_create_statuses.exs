defmodule Core.Repo.Migrations.CreateStatuses do
  use Ecto.Migration

  def change do
    create table(:statuses, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :active, :boolean, null: false, default: true
      add :description, :string, null: true
      add :status_name, :string, null: false
      add :status_code, :integer, null: false

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end

    create(unique_index(:statuses, [:status_code], name: :statuses_status_code_index))
  end
end
