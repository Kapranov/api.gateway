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
  def get_message(id), do: Repo.get!(Message, id)

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
end
