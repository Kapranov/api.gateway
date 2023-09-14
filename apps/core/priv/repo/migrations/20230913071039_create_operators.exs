defmodule Core.Repo.Migrations.CreateOperators do
  use Ecto.Migration

  def change do
    create table(:operators, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :active, :boolean, null: false, default: true
      add :phone_code, :string, null: true
      add :config, :map
      add :inserted_at, :timestamp, null: false, default: fragment("NOW()")
      add :limit_count, :integer, null: true
      add :name_operator, :string, null: false
      add :operator_type_id, references(:operator_types, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :price_ext, :decimal, null: false, default: 0.0
      add :price_int, :decimal, null: false, default: 0.0
      add :priority, :integer, null: false
    end

    create(unique_index(:operators, [:name_operator], name: :operators_name_operator_index))
  end
end
