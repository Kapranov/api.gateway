defmodule Core.Settings.Setting do
  @moduledoc """
  Schema for Setting.
  """

  use Core.Model
  use EctoAnon.Schema

  alias Core.Settings.Helpers.SettingEnum
  alias FlakeId.Ecto.Type, as: FlakeIdType

  @type t :: %__MODULE__{
    id: FlakeIdType,
    param: String.t(),
    value: String.t()
  }

  @min_chars 5
  @max_chars 100

  @allowed_params ~w(param value)a
  @required_params ~w(param value)a

  anon_schema [:param, :value]

  schema "settings" do
    field :param, :string
    field :value, SettingEnum

    timestamps()
    anonymized()
  end

  @doc """
  Create changeset for Setting.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_length(:param, min: @min_chars, max: @max_chars)
    |> foreign_key_constraint(:param, message: "Select the Param")
    |> unique_constraint(:param, name: :settings_param_index, message: "The param a name is unique")
  end
end
