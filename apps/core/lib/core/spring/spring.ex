defmodule Core.Spring do
  @moduledoc """
  The Message context.
  """

  use Core.Context

  alias Core.{
    Logs.SmsLog,
    Queries,
    Repo,
    Spring.Message
  }

  @doc """
  Gets a single Message.

  Raises `Ecto.NoResultsError` if Message does not exist.

  ## Examples

      iex> get_message(123)
      %Message{}

      iex> get_message(456)
      {:error, %Ecto.Changeset{}}

  """
  @spec get_message(Message.t()) :: Message.t() | error_tuple()
  def get_message(id) do
    try do
      Repo.get!(Message, id)
      |> Repo.preload([status: [:sms_logs]])
    rescue
      Ecto.NoResultsError ->
        {:error, %Ecto.Changeset{}}
    end
  end

  @doc """
  Creates Message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_message(%{atom => any}) :: result() | error_tuple()
  def create_message(attrs \\ %{}) do
    created =
      %Message{}
      |> Message.changeset(attrs)
      |> Repo.insert()

    case created do
      {:error, %Ecto.Changeset{}} -> {:error, %Ecto.Changeset{}}
      {:ok, struct} ->
        {:ok, Repo.preload(struct, [:sms_logs, status: [:sms_logs]])}
    end
  end

  @doc """
  Creates Message with SmsLogs and sorted Operators

  ## Examples

      iex> create_message_via_connector(%{field: value})
      {:ok, %Message{}}

      iex> create_message_via_connector(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_message_via_connector(%{atom => any}) :: result() | error_tuple()
  def create_message_via_connector(attrs \\ %{}) do
    message_changeset = Message.changeset(%Message{}, attrs)
    Multi.new
    |> Multi.insert(:messages, message_changeset)
    |> Multi.run(:sms_logs, fn _, %{messages: message} ->
      sms_log_changeset = SmsLog.changeset(%SmsLog{}, %{
        priority: 1,
        messages: message.id,
        statuses: message.status_id
      })
      Repo.insert(sms_log_changeset)
    end)
    |> Multi.run(:sorted_operators, fn _, %{messages: message} ->
      operators = Queries.sorted_by_operators(message.phone_number)
      {:ok, operators}
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{messages: message}} ->
        {:ok, message}
      {:ok, %{sms_logs: _sms_log}} ->
        {:ok, []}
      {:ok, %{sorted_operators: _operators}} ->
        {:ok, []}
      {:error, _model, changeset, _completed} ->
        {:ok, changeset}
    end
  end

  @doc """
  Updates Message.

  ## Examples

      iex> update_message(struct, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_message(Message.t(), %{atom => any}) :: result() | error_tuple()
  def update_message(%Message{} = struct, attrs) do
    try do
      struct
      |> Message.changeset(attrs)
      |> Repo.update()
    rescue
      Ecto.NoResultsError ->
        {:error, %Ecto.Changeset{}}
    end
  end
end
