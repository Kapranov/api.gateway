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
  def list_operator_type do
    Repo.all(OperatorType)
    |> Repo.preload(:operator)
  end

  @doc """
  Returns the list of Operator.
  """
  @spec list_operator() :: [Operator.t()]
  def list_operator do
    Repo.all(Operator)
    |> Repo.preload([:operator_type, :sms_logs])
  end

  @doc """
  Gets a single an OperatorType.

  Raises `Ecto.NoResultsError` if OperatorType does not exist.

  ## Examples

      iex> get_operator_type(123)
      %OperatorType{}

      iex> get_operator_type(456)
      {:error, %Ecto.Changeset{}}

  """
  @spec get_operator_type(String.t()) :: OperatorType.t() | error_tuple()
  def get_operator_type(id) do
    try do
      Repo.get!(OperatorType, id)
      |> Repo.preload(:operator)
    rescue
      Ecto.NoResultsError ->
        {:error, %Ecto.Changeset{}}
    end
  end

  @doc """
  Gets a single an Operator.

  Raises `Ecto.NoResultsError` if Operator does not exist.

  ## Examples

      iex> get_operator(123)
      %Operator{}

      iex> get_operator(456)
      {:error, %Ecto.Changeset{}}

  """
  @spec get_operator(String.t()) :: Operator.t() | error_tuple()
  def get_operator(id) do
    try do
      Repo.get!(Operator, id)
      |> Repo.preload(:sms_logs)
    rescue
      Ecto.NoResultsError ->
        {:error, %Ecto.Changeset{}}
    end
  end

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
    try do
      %Operator{}
      |> Operator.changeset(attrs)
      |> Repo.insert()
    rescue
      Ecto.ConstraintError ->
        {:error, %Ecto.Changeset{}}
    end
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
    try do
      struct
      |> OperatorType.changeset(attrs)
      |> Repo.update()
    rescue
      Ecto.NoResultsError ->
        {:error, %Ecto.Changeset{}}
    end
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
    try do
      struct
      |> Operator.changeset(attrs)
      |> Repo.update()
    rescue
      Ecto.NoResultsError ->
        {:error, %Ecto.Changeset{}}
      Ecto.ConstraintError ->
        {:error, %Ecto.Changeset{}}
    end
  end
end
