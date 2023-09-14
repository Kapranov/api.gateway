defmodule Core.Settings.Setting do
  @moduledoc """
  Schema for Setting.
  """

  use Core.Model

  @type t :: %__MODULE__{
    id: String.t(),
    param: String.t(),
    value: String.t()
  }

  @min_chars 10
  @max_chars 13

  @allowed_params ~w(param value)a
  @required_params ~w(param value)a

  schema "settings" do
    field :param, :string
    field :value, :string

    timestamps()
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
    |> validate_length(:value, min: @min_chars, max: @max_chars)
    |> unique_constraint(:param, name: :settings_param_index, message: "The param a name is unique")
  end
end
