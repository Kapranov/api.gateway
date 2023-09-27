defmodule Core.Spring do
  @moduledoc """
  The Message context.
  """

  use Core.Context

  alias Core.{
    Spring.Message,
    Repo
  }

  @doc """
  Gets a single Message.

  Raises `Ecto.NoResultsError` if Message does not exist.

  ## Examples

      iex> get_message(123)
      %Message{}

      iex> get_message(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_message(Message.t()) :: Message.t() | error_tuple()
  def get_message(id) do
    try do
      Repo.get!(Message, id)
      |> Repo.preload(:sms_logs)
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
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
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
    struct
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Message Changes.

  ## Examples

      iex> change_message(struct)
      %Ecto.Changeset{source: %Message{}}

  """
  @spec change_message(Message.t()) :: Ecto.Changeset.t()
  def change_message(%Message{} = struct) do
    Message.changeset(struct, %{})
  end
end
