defmodule Core.Spring.Message do
  @moduledoc """
  Schema for Message.
  """

  use Core.Model

  alias Core.{
    Logs.SmsLog,
    Monitoring.Status
  }

  alias FlakeId.Ecto.Type, as: FlakeIdType

  @type t :: %__MODULE__{
    id: FlakeIdType,
    id_external: String.t(),
    id_tax: integer,
    id_telegram: String.t(),
    message_body: String.t(),
    message_expired_at: DateTime.t(),
    phone_number: String.t(),
    sms_logs: [SmsLog.t()],
    status_changed_at: DateTime.t(),
    status_id: Status.t()
  }

  @min_chars_for_id_external 1
  @min_chars_for_id_telegram 10
  @min_chars_for_message_body 5
  @min_chars_for_phone_number 12
  @max_chars_for_id_external 10
  @max_chars_for_id_telegram 11
  @max_chars_for_message_body 255
  @max_chars_for_phone_number 12

  @allowed_params ~w(
    id_external
    id_tax
    id_telegram
    message_body
    message_expired_at
    phone_number
    status_changed_at
    status_id
  )a

  @required_params ~w(
    message_body
    phone_number
    status_id
  )a

  schema "messages" do
    field :id_external, :string
    field :id_tax, :integer
    field :id_telegram, :string
    field :message_body, :string
    field :message_expired_at, :utc_datetime_usec
    field :phone_number, :string
    field :status_changed_at, :utc_datetime_usec

    belongs_to :status, Status,
      foreign_key: :status_id,
      type: FlakeIdType,
      references: :id

    many_to_many :sms_logs, SmsLog, join_through: "sms_logs_messages", on_replace: :delete

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
    |> validate_length(:id_telegram, min: @min_chars_for_id_telegram, max: @max_chars_for_id_telegram)
    |> validate_length(:phone_number, min: @min_chars_for_phone_number, max: @max_chars_for_phone_number)
    |> validate_length(:message_body, min: @min_chars_for_message_body, max: @max_chars_for_message_body)
    |> validate_inclusion(:id_tax, 1..10)
  end
end
