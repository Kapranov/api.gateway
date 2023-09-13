defmodule Core.Operators.Operator do
  @moduledoc """
  Schema for Operator.
  """

  use Core.Model

  alias Core.Operators.{
    Config,
    Helpers.OperatorsEnum,
    OperatorType
  }

  @type t :: %__MODULE__{
    active: boolean,
    config: map,
    id: String.t(),
    inserted_at: DateTime.t(),
    limit_count: integer,
    name: String.t(),
    operator_type_id: OperatorType.t(),
    price_ext: integer,
    price_int: integer,
    priority: integer,
  }

  @zero 0

  @allowed_params ~w(
    active
    config
    inserted_at
    limit_count
    name
    operator_type_id
    price_ext
    price_int
    priority
  )a

  @required_params ~w(
    name
    operator_type_id
    price_ext
    price_int
  )a

  schema "operators" do
    field :active, :boolean
    field :limit_count, :integer
    field :name, OperatorsEnum
    field :price_ext, :decimal
    field :price_int, :decimal
    field :priority, :integer

    embeds_one(:config, Config, on_replace: :update)

    belongs_to :operator_type, OperatorType,
      foreign_key: :operator_type_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

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
    |> validate_number(:price_ext, greater_than_or_equal_to: @zero)
    |> validate_number(:price_int, greater_than_or_equal_to: @zero)
    |> validate_inclusion(:priority, 1..99)
    |> validate_inclusion(:limit_count, 1..99)
    |> foreign_key_constraint(:operator_type_id, message: "Select the Operator Type")
    |> unique_constraint(:operator_type_id, name: :operators_operator_type_id_index)
  end
end
