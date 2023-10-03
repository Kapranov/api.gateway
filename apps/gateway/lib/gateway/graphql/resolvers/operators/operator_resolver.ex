defmodule Gateway.GraphQL.Resolvers.Operators.OperatorResolver do
  @moduledoc """
  The Operator GraphQL resolvers.
  """

  alias Core.{
    Repo,
    Operators,
    Operators.Operator
  }

  @type t :: map
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{token: String.t()}}) :: result()
  def list(_parent, _args, %{context: %{token: token}}) do
    if is_nil(token) do
      {:error, "Can't be blank or Permission denied for token to perform action List"}
    else
      struct = Operators.list_operator()
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{token: String.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{token: token}}) do
    if is_nil(id) || is_nil(token) do
      {:error, "Can't be blank or Permission denied for token to perform action Show"}
    else
      try do
        struct = Operators.get_operator(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Operator #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec create(any, %{atom => any}, %{context: %{token: String.t()}}) :: result()
  def create(_parent, args, %{context: %{token: token}}) do
    if is_nil(token) do
      {:error, "Permission denied for token to perform action Create"}
    else
      args
      |> Operators.create_operator()
      |> case do
        {:ok, struct} ->
          {:ok, struct}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, operator: map()}, %{context: %{token: String.t()}}) :: result()
  def update(_parent, %{id: id, operator: params}, %{context: %{token: token}}) do
    if is_nil(id) || is_nil(token) do
      {:error, "Can't be blank or Permission denied for token to perform action Update"}
    else
      Repo.get!(Operator, id)
      |> Operators.update_operator(params)
      |> case do
        {:ok, struct} ->
          {:ok, struct}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec extract_error_msg(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp extract_error_msg(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
      [
        field: field,
        message: String.capitalize(error)
      ]
    end)
  end
end
