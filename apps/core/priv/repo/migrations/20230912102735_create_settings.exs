defmodule Core.Repo.Migrations.CreateSettingTypes do
  use Ecto.Migration
  import EctoAnon.Migration

  def change do
    create table(:settings, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"), read_after_writes: true
      add :param, :string, null: false, default: "calc_priority"
      add :value, :string, null: false, default: "priority"

      timestamps(type: :utc_datetime_usec)
      anonymized()
    end

    create(unique_index(:settings, [:param], name: :settings_param_index))
  end
end
