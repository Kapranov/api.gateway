defmodule Gateway.GraphQL.Resolvers.Monitoring.StatusResolver do
  @moduledoc """
  The Status GraphQL resolvers.
  """

  alias Core.Monitoring

  @type t :: map
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:ok, nil}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{token: String.t()}}) :: result()
  def list(_parent, _args, %{context: %{token: token}}) do
    if is_nil(token) do
      {:ok, nil}
    else
      struct = Monitoring.list_status()
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions), do: {:ok, nil}

  @spec show(any, %{id: bitstring}, %{context: %{token: String.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{token: token}}) do
    if is_nil(id) || is_nil(token) do
      {:ok, nil}
    else
      try do
        struct = Monitoring.get_status(id)
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
      |> Monitoring.create_status()
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
end
