defmodule Core.Logs do
  @moduledoc """
  The Log context.
  """

  use Core.Context

  alias Core.{
    Logs.SmsLog,
    Repo
  }

  @doc """
  Gets a single SmsLog.

  Raises `Ecto.NoResultsError` if SmsLog does not exist.

  ## Examples

      iex> get_sms_log(123)
      %SmsLog{}

      iex> get_sms_log(456)
      {:error, %Ecto.Changeset{}}

  """
  @spec get_sms_log(String.t()) :: SmsLog.t() | error_tuple()
  def get_sms_log(id) do
    try do
      Repo.get!(SmsLog, id)
      |> Repo.preload([:messages, :statuses, operators: [:operator_type]])
    rescue
      Ecto.NoResultsError ->
        {:error, %Ecto.Changeset{}}
    end
  end

  @doc """
  Creates SmsLog.

  ## Examples

      iex> create_sms_log(%{field: value})
      {:ok, %SmsLog{}}

      iex> create_sms_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_sms_log(%{atom => any}) :: result() | error_tuple()
  def create_sms_log(attrs \\ %{}) do
    %SmsLog{}
    |> SmsLog.changeset(attrs)
    |> Repo.insert()
  end
end
