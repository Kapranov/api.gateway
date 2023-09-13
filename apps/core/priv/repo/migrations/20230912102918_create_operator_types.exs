defmodule Core.Repo.Migrations.CreateOperatorTypes do
  use Ecto.Migration

  def change do
    create table(:operator_types, primary_key: false) do
      add :active, :boolean, default: true, null: false
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :inserted_at, :timestamp, null: false, default: fragment("NOW()")
      add :name, :string, null: false, default: "gsm"
      add :priority, :integer, null: true
    end

    create(unique_index(:operator_types, [:name], name: :operator_types_name_index))
  end
end
