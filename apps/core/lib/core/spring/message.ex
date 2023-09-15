defmodule Core.Spring.Message do
  @moduledoc """
  Schema for Message.
  """

  use Core.Model

  alias Core.Monitoring.Status

  @type t :: %__MODULE__{
    id: String.t(),
    id_external: String.t(),
    id_tax: String.t(),
    id_telegram: String.t(),
    inserted_at: DateTime.t(),
    message_body: String.t(),
    message_expired_at: DateTime.t(),
    phone_number: String.t(),
    status_id: Status.t()
  }

  @min_chars_for_id_external 5
  @min_chars_for_id_tax 5
  @min_chars_for_id_telegram 5
  @min_chars_for_message_body 5
  @min_chars_for_phone_number 5
  @max_chars_for_id_external 255
  @max_chars_for_id_tax 10
  @max_chars_for_id_telegram 100
  @max_chars_for_message_body 255
  @max_chars_for_phone_number 13

  @allowed_params ~w(
    id_external
    id_tax
    id_telegram
    inserted_at
    message_body
    message_expired_at
    phone_number
    status_id
  )a

  @required_params ~w(
    message_body
    phone_number
    status_id
  )a

  schema "messages" do
    field :id_external, :string
    field :id_tax, :string
    field :id_telegram, :string
    field :message_body, :string
    field :message_expired_at, :date
    field :phone_number, :string

    belongs_to :status, Status,
      foreign_key: :status_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    timestamps(updated_at: false)
  end

  @doc """
  Create changeset for Message.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_length(:id_external, min: @min_chars_for_id_external, max: @max_chars_for_id_external)
    |> validate_length(:id_tax, min: @min_chars_for_id_tax, max: @max_chars_for_id_tax)
    |> validate_length(:id_telegram, min: @min_chars_for_id_telegram, max: @max_chars_for_id_telegram)
    |> validate_length(:phone_number, min: @min_chars_for_phone_number, max: @max_chars_for_phone_number)
    |> validate_length(:message_body, min: @min_chars_for_message_body, max: @max_chars_for_message_body)
  end
end
