defmodule Core.Operators do
  @moduledoc """
  The Operators context.
  """

  use Core.Context

  alias Core.{
    Operators.Operator,
    Operators.OperatorType,
    Repo
  }

  @doc """
  Returns the list of OperatorType.
  """
  @spec list_operator_type() :: [OperatorType.t()]
  def list_operator_type, do: Repo.all(OperatorType)

  @doc """
  Returns the list of Operator.
  """
  @spec list_operator() :: [Operator.t()]
  def list_operator, do: Repo.all(Operator)

  @doc """
  Gets a single an OperatorType.

  Raises `Ecto.NoResultsError` if OperatorType does not exist.

  ## Examples

      iex> get_operator_type(123)
      %OperatorType{}

      iex> get_operator_type(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_operator_type(String.t()) :: OperatorType.t() | error_tuple()
  def get_operator_type(id), do: Repo.get!(OperatorType, id)

  @doc """
  Gets a single an Operator.

  Raises `Ecto.NoResultsError` if Operator does not exist.

  ## Examples

      iex> get_operator(123)
      %Operator{}

      iex> get_operator(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_operator(String.t()) :: Operator.t() | error_tuple()
  def get_operator(id), do: Repo.get!(Operator, id)

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
  Creates an Operator.

  ## Examples

      iex> create_operator(%{field: value})
      {:ok, %Operator{}}

      iex> create_operator(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_operator(%{atom => any}) :: result() | error_tuple()
  def create_operator(attrs \\ %{}) do
    %Operator{}
    |> Operator.changeset(attrs)
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
  Updates an Operator.

  ## Examples

      iex> update_operator(struct, %{field: new_value})
      {:ok, %Operator{}}

      iex> update_operator(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_operator(Operator.t(), %{atom => any}) :: result() | error_tuple()
  def update_operator(%Operator{} = struct, attrs) do
    struct
    |> Operator.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking an OperatorType Changes.

  ## Examples

      iex> change_operator_type(struct)
      %Ecto.Changeset{source: %OperatorType{}}

  """
  @spec change_operator_type(OperatorType.t()) :: Ecto.Changeset.t()
  def change_operator_type(%OperatorType{} = struct) do
    OperatorType.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking an Operator Changes.

  ## Examples

      iex> change_operator(struct)
      %Ecto.Changeset{source: %Operator{}}

  """
  @spec change_operator(Operator.t()) :: Ecto.Changeset.t()
  def change_operator(%Operator{} = struct) do
    Operator.changeset(struct, %{})
  end
end