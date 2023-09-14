defmodule Core.Operators.Operator do
  @moduledoc """
  Schema for Operator.
  """

  use Core.Model

  alias Core.Operators.{
    Config,
    OperatorType
  }

  @type t :: %__MODULE__{
    active: boolean,
    phone_code: String.t(),
    config: map,
    id: String.t(),
    inserted_at: DateTime.t(),
    limit_count: integer,
    name_operator: String.t(),
    operator_type_id: OperatorType.t(),
    price_ext: integer,
    price_int: integer,
    priority: integer
  }

  @min_chars 5
  @max_chars 100
  @zero 0

  @allowed_params ~w(
    active
    phone_code
    inserted_at
    limit_count
    name_operator
    operator_type_id
    price_ext
    price_int
    priority
  )a

  @required_params ~w(
    active
    name_operator
    operator_type_id
    price_ext
    price_int
    priority
  )a

  schema "operators" do
    field :active, :boolean
    field :limit_count, :integer
    field :name_operator, :string
    field :phone_code, :string
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
    |> cast_embed(:config)
    |> validate_required(@required_params)
    |> validate_length(:name_operator, min: @min_chars, max: @max_chars)
    |> validate_number(:price_ext, greater_than_or_equal_to: @zero)
    |> validate_number(:price_int, greater_than_or_equal_to: @zero)
    |> validate_inclusion(:priority, 1..99)
    |> validate_inclusion(:limit_count, 1..99)
    |> foreign_key_constraint(:name_operator, message: "Select the Name Operator")
    |> unique_constraint(:name_operator, name: :operators_name_operator_index)
  end
end
