defmodule Core.Operators do
  @moduledoc """
  The Operators context.
  """

  use Core.Context

  alias Core.{
    Operators.OperatorType,
    Repo
  }

  @doc """
  Returns the list of OperatorType.
  """
  @spec list_operator_type() :: [OperatorType.t()]
  def list_operator_type, do: Repo.all(OperatorType)

  @doc """
  Gets a single an OperatorType.

  Raises `Ecto.NoResultsError` if an Addon does not exist.

  ## Examples

      iex> get_operator_type(123)
      %OperatorType{}

      iex> get_operator_type(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_operator_type(String.t()) :: OperatorType.t() | error_tuple()
  def get_operator_type(id), do: Repo.get!(OperatorType, id)

  @doc """
  Creates an OperatorType.

  ## Examples

      iex> create_operator_type(%{field: value})
      {:ok, %OperatorType{}}

      iex> create_operator_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_operator_type(%{atom => any}) :: result() | error_tuple()
  def create_operator_type(attrs \\ %{}) do
    %OperatorType{}
    |> OperatorType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an OperatorType.

  ## Examples

      iex> update_operator_type(struct, %{field: new_value})
      {:ok, %OperatorType{}}

      iex> update_operator_type(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_operator_type(OperatorType.t(), %{atom => any}) :: result() | error_tuple()
  def update_operator_type(%OperatorType{} = struct, attrs) do
    struct
    |> OperatorType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an OperatorType.

  ## Examples

      iex> delete_operator_type(struct)
      {:ok, %OperatorType{}}

      iex> delete_operator_type(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_operator_type(OperatorType.t()) :: result()
  def delete_operator_type(%OperatorType{} = struct) do
     Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking an OperatorType Changes.

  ## Examples

      iex> change_operator_type(struct)
      %Ecto.Changeset{source: %OperatorType{}}

  """
  @spec change_offer(OperatorType.t()) :: Ecto.Changeset.t()
  def change_offer(%OperatorType{} = struct) do
    OperatorType.changeset(struct, %{})
  end
end
