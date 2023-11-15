defmodule Gateway.GraphQL.Resolvers.Spring.MessageResolver do
  @moduledoc """
  The Message GraphQL resolvers.
  """

  alias Core.{
    Operators.Operator,
    Queries,
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
    |> Spring.create_message_for_connector()
    |> case do
      {:error, %Ecto.Changeset{}} ->
        {:ok, []}
      {:ok, struct} ->
        {:ok, struct}
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info), do: {:ok, []}

  @spec update(any, %{id: bitstring, message: map()}, %{context: %{token: String.t()}}) :: result()
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

  @spec sorted_operators(any, String.t(), %{context: %{token: String.t()}}) :: result()
  def sorted_operators(_parent, args, %{context: %{token: _token}}) do
    structs = Queries.sorted_by_operators(args.phone_number)
    {:ok, structs}
  end

  @spec sorted_operators(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def sorted_operators(_parent, _args, _info), do: {:ok, []}

  @spec selected_connector([Operator.t()], String.t()) :: [Operator.t()] | []
  def selected_connector(operators, message_id) do
    Enum.reduce(operators, [], fn(x, acc) ->
      case x.config.name do
        "dia" ->
          case Connector.DiaHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.DiaHandler.get_status(pid) do
                :error ->
                  :ok = Connector.DiaHandler.stop(pid)
                  acc
                :timeout ->
                  :ok = Connector.DiaHandler.stop(pid)
                  acc
                data ->
                  :ok = Connector.DiaHandler.stop(pid)
                  data
              end
            _ -> {:ok, []}
          end
        "intertelecom" ->
          case Connector.IntertelecomHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.IntertelecomHandler.get_status(pid) do
                :error ->
                  :ok = Connector.IntertelecomHandler.stop(pid)
                  acc
                :timeout ->
                  :ok = Connector.IntertelecomHandler.stop(pid)
                  acc
                data ->
                  :ok = Connector.IntertelecomHandler.stop(pid)
                  data
              end
            _ -> {:ok, []}
          end
        "kyivstar" ->
          case Connector.KyivstarHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.KyivstarHandler.get_status(pid) do
                :error ->
                  :ok = Connector.KyivstarHandler.stop(pid)
                  acc
                :timeout ->
                  :ok = Connector.KyivstarHandler.stop(pid)
                  acc
                data ->
                  :ok = Connector.KyivstarHandler.stop(pid)
                  data
              end
            _ -> {:ok, []}
          end
        "lifecell" ->
          case Connector.LifecellHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.LifecellHandler.get_status(pid) do
                :error ->
                  :ok = Connector.LifecellHandler.stop(pid)
                  acc
                :timeout ->
                  :ok = Connector.LifecellHandler.stop(pid)
                  acc
                data ->
                  :ok = Connector.LifecellHandler.stop(pid)
                  data
              end
            _ -> {:ok, []}
          end
        "telegram" ->
          case Connector.TelegramHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.TelegramHandler.get_status(pid) do
                :error ->
                  :ok = Connector.TelegramHandler.stop(pid)
                  acc
                :timeout ->
                  :ok = Connector.TelegramHandler.stop(pid)
                  acc
                data ->
                  :ok = Connector.TelegramHandler.stop(pid)
                  data
              end
            _ -> {:ok, []}
          end
        "viber" ->
          case Connector.ViberHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.ViberHandler.get_status(pid) do
                :error ->
                  :ok = Connector.ViberHandler.stop(pid)
                  acc
                :timeout ->
                  :ok = Connector.ViberHandler.stop(pid)
                  acc
                data ->
                  :ok = Connector.ViberHandler.stop(pid)
                  data
              end
            _ -> {:ok, []}
          end
        "vodafone" ->
          case Connector.VodafoneHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.VodafoneHandler.get_status(pid, 1_000) do
                :error ->
                  :ok = Connector.VodafoneHandler.stop(pid)
                  acc
                :timeout ->
                  :ok = Connector.VodafoneHandler.stop(pid)
                  acc
                data ->
                  :ok = Connector.VodafoneHandler.stop(pid)
                  data
              end
            _ -> {:ok, []}
          end
        _ -> acc
      end
    end)
  end
end
