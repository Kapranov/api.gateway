defmodule Core.Operators.OperatorType do
  @moduledoc """
  Schema for OperatorType.
  """

  use Core.Model

  alias Core.Operators.Operator
  alias FlakeId.Ecto.Type, as: FlakeIdType

  @type t :: %__MODULE__{
    id: FlakeIdType,
    active: boolean,
    name_type: String.t(),
    priority: integer
  }

  @min_chars 3
  @max_chars 100

  @allowed_params ~w(
    active
    name_type
    priority
  )a

  @required_params ~w(
    active
    name_type
  )a

  schema "operator_types" do
    field :active, :boolean, default: true
    field :name_type, :string
    field :priority, :integer

    has_one :operator, Operator, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Create changeset for OperatorType.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_length(:name_type, min: @min_chars, max: @max_chars)
    |> validate_inclusion(:priority, 1..99)
    |> foreign_key_constraint(:name_type, message: "Select the NameType")
    |> unique_constraint(:name_type, name: :operator_types_name_type_index)
  end
end
