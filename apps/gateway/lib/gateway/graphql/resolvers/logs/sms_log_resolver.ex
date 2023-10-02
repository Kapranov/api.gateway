defmodule Gateway.GraphQL.Resolvers.Logs.SmsLogResolver do
  @moduledoc """
  The SmsLog GraphQL resolvers.
  """

  alias Core.Logs

  @type t :: map
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec show(any, %{id: bitstring}, %{context: %{token: String.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{token: token}}) do
    if is_nil(id) || is_nil(token) do
      {:error, "Can't be blank or Permission denied for token to perform action Show"}
    else
      try do
        struct = Logs.get_sms_log(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The SmsLog #{id} not found!"}
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
      |> Logs.create_sms_log()
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
