defmodule Core.Repo.Migrations.CreateOperators do
  use Ecto.Migration

  def change do
    create table(:operators, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :active, :boolean, null: true
      add :config, {:array, :map}, default: []
      add :inserted_at, :timestamp, null: false, default: fragment("NOW()")
      add :limit_count, :integer, null: true
      add :name, :string, null: false, default: "vodafone"
      add :operator_type_id, references(:operator_types, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :price_ext, :decimal, null: false, default: 0.0
      add :price_int, :decimal, null: false, default: 0.0
      add :priority, :integer, null: true

      timestamps(type: :utc_datetime_usec)
    end

    create(unique_index(:operators, [:operator_type_id], name: :operators_operator_type_id_index))
  end
end
