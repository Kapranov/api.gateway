defmodule Gateway.GraphQL.Resolvers.Spring.MessageResolver do
  @moduledoc """
  The Message GraphQL resolvers.
  """

  alias Core.{
    Repo,
    Spring,
    Spring.Message
  }

  @type t :: map
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:ok, []}
  @type result :: success_tuple | error_tuple

  @spec show(any, %{id: bitstring}, %{context: %{token: String.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{token: _token}}) do
    case Spring.get_message(id) do
      {:error, %Ecto.Changeset{}} ->
        {:ok, []}
      struct ->
        {:ok, struct}
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info), do: {:ok, []}

  @spec create(any, %{atom => any}, %{context: %{token: String.t()}}) :: result()
  def create(_parent, args, %{context: %{token: _token}}) do
    args
    |> Spring.create_message()
    |> case do
      {:error, %Ecto.Changeset{}} ->
        {:ok, []}
      {:ok, struct} ->
        {:ok, struct}
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info), do: {:ok, []}

  @spec update(any, %{id: bitstring, setting: map()}, %{context: %{token: String.t()}}) :: result()
  def update(_parent, %{id: id, message: params}, %{context: %{token: _token}}) do
    try do
      Repo.get!(Message, id)
      |> Spring.update_message(params)
      |> case do
        {:error, %Ecto.Changeset{}} ->
          {:ok, []}
        {:ok, struct} ->
          {:ok, struct}
      end
    rescue
      Ecto.NoResultsError ->
        {:ok, []}
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info), do: {:ok, []}
end
