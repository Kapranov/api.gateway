defmodule Core.Operators.Config do
  @moduledoc """
  Represents the config entity for operators.
  """

  use Core.Model

  import Ecto.Changeset, only: [
    cast: 3,
    validate_required: 2
  ]

  alias Core.Operators.Parameters
  alias FlakeId.Ecto.Type, as: FlakeIdType

  @type t :: %__MODULE__{
    id: FlakeIdType,
    content_type: String.t(),
    name: String.t(),
    parameters: Parameters.t(),
    size: integer,
    url: String.t()
  }

  @required_attrs [:name, :url]
  @optional_attrs [:content_type, :size]
  @attrs @required_attrs ++ @optional_attrs

  embedded_schema do
    embeds_one(:parameters, Parameters, on_replace: :update)
    field :content_type, :string
    field :name,         :string
    field :size,         :integer
    field :url,          :string

    timestamps()
  end

  @doc """
  Create changeset for Config.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = config, attrs) do
    config
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end
