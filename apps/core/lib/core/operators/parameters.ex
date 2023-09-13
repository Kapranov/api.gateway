defmodule Core.Operators.Parameters do
  @moduledoc """
  Represents the parameters entity for config.
  """

  use Core.Model

  import Ecto.Changeset, only: [
    cast: 3,
    validate_required: 2
  ]

  @type t :: %__MODULE__{
    key: String.t(),
    value: String.t()
  }

  @required_attrs [:key, :value]
  @optional_attrs []
  @attrs @required_attrs ++ @optional_attrs

  embedded_schema do
    field :key, :string
    field :value, :string

    timestamps()
  end

  @doc """
  Create changeset for Parameters.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end
