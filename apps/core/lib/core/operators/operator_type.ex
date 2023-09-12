defmodule Core.Operators.OperatorType do
  @moduledoc """
  Schema for OperatorType.
  """

  use Core.Model

  alias Core.Operators.Helpers.OperatorTypesEnum

  @type t :: %__MODULE__{
    active: boolean,
    id: String.t(),
    inserted_at: DateTime.t(),
    name: String.t(),
    priority: integer
  }

  @allowed_params ~w(
    active
    inserted_at
    name
    priority
  )a

  @required_params ~w(
    active
    name
  )a

  schema "operator_types" do
    field :active, :boolean
    field :name, OperatorTypesEnum
    field :priority, :integer

    timestamps(updated_at: false)
  end

  @doc """
  Create changeset for OperatorType.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_inclusion(:priority, 1..99)
  end
end
