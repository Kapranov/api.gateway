defmodule Core.Repo.Migrations.CreateOperatorTypes do
  use Ecto.Migration

  def change do
    create table(:operator_types, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :active, :boolean, null: false, default: true
      add :name_type, :string, null: false
      add :priority, :integer, null: true

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:operator_types, [:name_type], name: :operator_types_name_type_index))
  end
end
