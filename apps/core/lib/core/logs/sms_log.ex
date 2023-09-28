defmodule Core.Logs.SmsLog do
  @moduledoc """
  Schema for SmsLog.
  """

  use Core.Model

  alias Core.{
    Monitoring.Status,
    Operators.Operator,
    Repo,
    Spring.Message
  }

  alias FlakeId.Ecto.Type, as: FlakeIdType

  @type t :: %__MODULE__{
    id: FlakeIdType,
    messages: [Message.t()],
    operators: [Operator.t()],
    priority: integer,
    statuses: [Status.t()]
  }

  @allowed_params ~w(priority)a
  @required_params ~w(priority)a

  schema "sms_logs" do
    field :priority, :integer

    many_to_many :messages, Message, join_through: "sms_logs_messages", on_replace: :delete
    many_to_many :operators, Operator, join_through: "sms_logs_operators", on_replace: :delete
    many_to_many :statuses, Status, join_through: "sms_logs_statuses", on_replace: :delete

    timestamps(updated_at: false)
  end

  @doc """
  Create changeset for SmsLog.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> changeset_preload([:messages, :operators, :statuses])
    |> put_assoc_nochange(:messages, parse_id_for_message(attrs))
    |> put_assoc_nochange(:operators, parse_id_for_operator(attrs))
    |> put_assoc_nochange(:statuses, parse_id_for_status(attrs))
    |> validate_inclusion(:priority, 1..99)
    |> validate_message_count
    |> validate_operator_count
    |> validate_status_count
  end

  @spec changeset_preload(map, Keyword.t()) :: Ecto.Changeset.t()
  def changeset_preload(ch, field),
    do: update_in(ch.data, &Repo.preload(&1, field))

  @spec put_assoc_nochange(map, Keyword.t(), map) :: Ecto.Changeset.t()
  def put_assoc_nochange(ch, field, new_change) do
    case get_change(ch, field) do
      nil -> put_assoc(ch, field, new_change)
      _ -> ch
    end
  end

  @spec parse_id_for_message(%{atom => any}) :: map()
  defp parse_id_for_message(params) do
    (params[:messages] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.map(&get_or_insert_message/1)
  end

  @spec parse_id_for_operator(%{atom => any}) :: map()
  defp parse_id_for_operator(params) do
    (params[:operators] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.map(&get_or_insert_operator/1)
  end

  @spec parse_id_for_status(%{atom => any}) :: map()
  defp parse_id_for_status(params) do
    (params[:statuses] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.map(&get_or_insert_status/1)
  end

  @spec get_or_insert_message(String.t()) :: map()
  defp get_or_insert_message(id) do
    Repo.get_by(Message, id: id) || maybe_insert_message(id)
  end

  @spec get_or_insert_operator(String.t()) :: map()
  defp get_or_insert_operator(id) do
    Repo.get_by(Operator, id: id) || maybe_insert_operator(id)
  end

  @spec get_or_insert_status(String.t()) :: map()
  defp get_or_insert_status(id) do
    Repo.get_by(Status, id: id) || maybe_insert_status(id)
  end

  @spec maybe_insert_message(String.t()) :: map()
  defp maybe_insert_message(id) do
   %Message{}
    |> Ecto.Changeset.change(id: id)
    |> Ecto.Changeset.unique_constraint(:id)
    |> Repo.insert!(on_conflict: [set: [id: id]], conflict_target: :id)
    |> case do
      {:ok, struct} -> struct
      {:error, _} -> Repo.get_by!(Message, id: id)
    end
  end

  @spec maybe_insert_operator(String.t()) :: map()
  defp maybe_insert_operator(id) do
    %Operator{}
    |> Ecto.Changeset.change(id: id)
    |> Ecto.Changeset.unique_constraint(:id)
    |> Repo.insert!(on_conflict: [set: [id: id]], conflict_target: :id)
    |> case do
      {:ok, struct} -> struct
      {:error, _} -> Repo.get_by!(Operator, id: id)
    end
  end

  @spec maybe_insert_status(String.t()) :: map()
  defp maybe_insert_status(id) do
    %Status{}
    |> Ecto.Changeset.change(id: id)
    |> Ecto.Changeset.unique_constraint(:id)
    |> Repo.insert!(on_conflict: [set: [id: id]], conflict_target: :id)
    |> case do
      {:ok, struct} -> struct
      {:error, _} -> Repo.get_by!(Status, id: id)
    end
  end

  @spec validate_message_count(t) :: Ecto.Changeset.t()
  defp validate_message_count(changeset) do
    messages = Repo.all(Ecto.assoc(changeset.data, :messages))
    valid? = length(messages) == 2

    if valid? do
      add_error(changeset, :messages, "hello")
    else
      changeset
    end
  end

  @spec validate_operator_count(t) :: Ecto.Changeset.t()
  defp validate_operator_count(changeset) do
    operators = Repo.all(Ecto.assoc(changeset.data, :operators))
    valid? = length(operators) == 2

    if valid? do
      add_error(changeset, :operators, "hello")
    else
      changeset
    end
  end

  @spec validate_status_count(t) :: Ecto.Changeset.t()
  defp validate_status_count(changeset) do
    statuses = Repo.all(Ecto.assoc(changeset.data, :statuses))
    valid? = length(statuses) == 2

    if valid? do
      add_error(changeset, :statuses, "hello")
    else
      changeset
    end
  end
end
