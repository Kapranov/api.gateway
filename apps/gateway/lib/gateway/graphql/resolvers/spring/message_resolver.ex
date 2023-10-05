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
  @type error_tuple :: {:ok, nil}
  @type result :: success_tuple | error_tuple

  @spec show(any, %{id: bitstring}, %{context: %{token: String.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{token: token}}) do
    if is_nil(id) || is_nil(token) do
      {:ok, nil}
    else
      try do
        struct = Spring.get_message(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:ok, nil}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info), do: {:ok, nil}

  @spec create(any, %{atom => any}, %{context: %{token: String.t()}}) :: result()
  def create(_parent, args, %{context: %{token: token}}) do
    if is_nil(token) do
      {:ok, nil}
    else
      args
      |> Spring.create_message()
      |> case do
        {:ok, struct} ->
          {:ok, struct}
        {:error, %Ecto.Changeset{}} ->
          {:ok, nil}
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info), do: {:ok, nil}

  @spec update(any, %{id: bitstring, setting: map()}, %{context: %{token: String.t()}}) :: result()
  def update(_parent, %{id: id, message: params}, %{context: %{token: token}}) do
    if is_nil(id) || is_nil(token) do
      {:ok, nil}
    else
      Repo.get!(Message, id)
      |> Spring.update_message(params)
      |> case do
        {:ok, struct} ->
          {:ok, struct}
        {:error, %Ecto.Changeset{}} ->
          {:ok, nil}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info), do: {:ok, nil}
end
