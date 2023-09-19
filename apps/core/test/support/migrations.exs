defmodule Core.Bench.CreateSetting do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add(:param, :string)
      add(:value, :string)
      add(:uuid, :binary_id)
    end
  end
end
