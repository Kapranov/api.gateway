defmodule Core.Monitoring.Status do
  @moduledoc """
  Schema for Status.
  """

  use Core.Model

  alias Core.{
    Logs.SmsLog,
    Spring.Message
  }

  alias FlakeId.Ecto.Type, as: FlakeIdType

  @type t :: %__MODULE__{
    id: FlakeIdType,
    active: boolean,
    description: String.t(),
    sms_logs: [SmsLog.t()],
    status_code: integer,
    status_name: String.t()
  }

  @min_chars 3
  @max_chars 100

  @allowed_params ~w(
    active
    description
    status_name
    status_code
  )a

  @required_params ~w(
    active
    status_name
    status_code
  )a

  schema "statuses" do
    field :active, :boolean, default: true
    field :description, :string
    field :status_name, :string
    field :status_code, :integer

    has_many :messages, Message

    many_to_many :sms_logs, SmsLog, join_through: "sms_logs_statuses", on_replace: :delete

    timestamps(updated_at: false)
  end

  @doc """
  Create changeset for Status.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_length(:description, min: @min_chars, max: @max_chars)
    |> validate_length(:status_name, min: @min_chars, max: @max_chars)
    |> validate_inclusion(:status_code, 1..200)
    |> foreign_key_constraint(:status_code, message: "Select the StatusCode")
    |> unique_constraint(:status_code, name: :statuses_status_code_index)
  end
end
