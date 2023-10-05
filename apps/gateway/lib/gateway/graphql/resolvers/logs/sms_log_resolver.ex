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
      {:ok, nil}
    else
      case Logs.get_sms_log(id) do
        {:error, %Ecto.Changeset{}} ->
          {:ok, nil}
        struct ->
          {:ok, struct}
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
      params = %{
        priority: args.priority,
        statuses: args.status_id,
        operators: args.operator_id,
        messages: args.message_id
      }

      params
      |> Logs.create_sms_log()
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
