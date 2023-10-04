defmodule Core.Monitoring do
  @moduledoc """
  The Monitoring context.
  """

  use Core.Context

  alias Core.{
    Monitoring.Status,
    Repo
  }

  @doc """
  Returns the list of Statuses.
  """
  @spec list_status() :: [Status.t()]
  def list_status do
    Repo.all(Status)
    |> Repo.preload([:messages, :sms_logs])
  end

  @doc """
  Gets a single Status.

  Raises `Ecto.NoResultsError` if Status does not exist.

  ## Examples

      iex> get_status(123)
      %Status{}

      iex> get_status(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_status(String.t()) :: Status.t() | error_tuple()
  def get_status(id) do
    try do
      Repo.get!(Status, id)
      |> Repo.preload([messages: [:sms_logs]])
    rescue
      Ecto.NoResultsError ->
        {:error, %Ecto.Changeset{}}
    end
  end

  @doc """
  Creates Status.

  ## Examples

      iex> create_status(%{field: value})
      {:ok, %Status{}}

      iex> create_status(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_status(%{atom => any}) :: result() | error_tuple()
  def create_status(attrs \\ %{}) do
    %Status{}
    |> Status.changeset(attrs)
    |> Repo.insert()
  end
end
