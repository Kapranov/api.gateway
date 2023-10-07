defmodule Core.Operators.Operator do
  @moduledoc """
  Schema for Operator.
  """

  use Core.Model
  require Decimal

  alias Core.{
    Logs.SmsLog,
    Operators.Config,
    Operators.OperatorType
  }

  alias FlakeId.Ecto.Type, as: FlakeIdType

  @type t :: %__MODULE__{
    id: FlakeIdType,
    active: boolean,
    config: map,
    limit_count: integer,
    name_operator: String.t(),
    operator_type_id: OperatorType.t(),
    phone_code: String.t(),
    price_ext: integer,
    price_int: integer,
    priority: integer,
    sms_logs: [SmsLog.t()]
  }

  @min_chars 3
  @max_chars 100
  @zero 0

  @allowed_params ~w(
    active
    limit_count
    name_operator
    operator_type_id
    phone_code
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
      type: FlakeIdType,
      references: :id

    many_to_many :sms_logs, SmsLog, join_through: "sms_logs_operators", on_replace: :delete

    timestamps()
  end

  @doc """
  Create changeset for Operator.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> cast_embed(:config, with: &Config.changeset/2)
    |> validate_required(@required_params)
    |> validate_decimal(:price_ext)
    |> validate_decimal(:price_int)
    |> validate_length(:name_operator, min: @min_chars, max: @max_chars)
    |> validate_number(:price_ext, greater_than_or_equal_to: @zero)
    |> validate_number(:price_int, greater_than_or_equal_to: @zero)
    |> validate_inclusion(:priority, 1..99)
    |> validate_inclusion(:limit_count, 0..100_000)
    |> foreign_key_constraint(:name_operator, message: "Select the Name Operator")
    |> unique_constraint(:name_operator, name: :operators_name_operator_index)
  end

  @spec validate_decimal(t, atom) :: Ecto.Changeset.t()
  def validate_decimal(changeset, field) do
    if integer?(get_field(changeset, field)) do
      changeset
    else
      add_error(changeset, field, "The float, integer is expected.")
    end
  end

  @spec integer?(integer) :: boolean
  defp integer?(target) when is_integer(target) do
    target
    |> Decimal.round()
    |> Decimal.equal?(target)
  end

  @spec integer?(float) :: boolean
  defp integer?(target) when is_float(target) do
    target
    |> Decimal.from_float()
    |> Decimal.equal?(Decimal.from_float(target))
  end

  defp integer?(target) when Decimal.is_decimal(target) do
    target
    |> Decimal.equal?(Decimal.to_string(target))
  end

  @spec integer?(any()) :: boolean
  defp integer?(_), do: false
end
