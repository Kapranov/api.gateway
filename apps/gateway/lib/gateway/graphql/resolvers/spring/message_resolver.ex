defmodule Gateway.GraphQL.Resolvers.Spring.MessageResolver do
  @moduledoc """
  The Message GraphQL resolvers.
  """

  alias Core.{
    Logs.SmsLog,
    Monitoring.Status,
    Operators.Operator,
    Queries,
    Repo,
    Spring,
    Spring.Message
  }

  alias Connector.Monitor
  alias Ecto.Multi
  alias Gateway.Kafka.Producer

  @topic Application.compile_env(:kaffe, :producer) |> Keyword.get(:topics) |> List.last

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

  @spec create_via_monitor(any, %{atom => any}, %{context: %{token: String.t()}}) :: result()
  def create_via_monitor(_parent, args, %{context: %{token: _token}}) do
    args
    |> Spring.create_message()
    |> case do
      {:error, %Ecto.Changeset{}} ->
        {:ok, []}
      {:ok, struct} ->
        {:ok, _pid} = Monitor.start_link([])
        message = ~s({"status":"send","text":"#{struct.message_body}","connector":"kafka","sms":"#{struct.phone_number}","ts":#{:os.system_time(:milli_seconds)}})
        messages = [%{key: struct.id, value: message}]
        Task.async(fn -> Monitor.produce(@topic, messages) end)
        {:ok, struct}
    end
  end

  @spec create_via_monitor(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create_via_monitor(_parent, _args, _info), do: {:ok, []}

  @spec create_via_kafka(any, %{atom => any}, %{context: %{token: String.t()}}) :: result()
  def create_via_kafka(_parent, args, %{context: %{token: _token}}) do
    args
    |> Spring.create_message()
    |> case do
      {:error, %Ecto.Changeset{}} ->
        {:ok, []}
      {:ok, struct} ->
        :ok = Producer.start_producer_client
        data = %{id: struct.id, phone_number: struct.phone_number, message_body: struct.message_body}
        Task.async(fn -> Producer.runner(data) end)
        {:ok, struct}
    end
  end

  @spec create_via_kafka(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create_via_kafka(_parent, _args, _info), do: {:ok, []}

  @spec create_via_connector(any, %{atom => any}, %{context: %{token: String.t()}}) :: result()
  def create_via_connector(_parent, args, %{context: %{token: _token}}) do
    args
    |> Spring.create_message()
    |> case do
      {:error, %Ecto.Changeset{}} -> {:ok, []}
      {:ok, struct} ->
        operators = Queries.sorted_by_operators(struct.phone_number)
        case by_connector(operators, struct) do
          [] -> {:ok, struct}
          connector ->
            status = Repo.get_by(Status, %{status_name: connector.status})
            changeset = Message.changeset(struct, %{
              status_id: status.id,
              message_body: "#{struct.message_body} - #{connector.connector}"
            })
            {:ok, _updated} = Repo.update(changeset)
            {:ok, struct}
        end
    end
  end

  @spec create_via_connector(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create_via_connector(_parent, _args, _info), do: {:ok, []}

  @spec create_via_multi(any, %{atom => any}, %{context: %{token: String.t()}}) :: result()
  def create_via_multi(_parent, args, %{context: %{token: _token}}) do
    args
    |> create_multi()
    |> case do
      {:error, %Ecto.Changeset{}} ->
        {:ok, []}
      {:ok, struct} ->
        {:ok, struct}
    end
  end

  @spec create_via_multi(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create_via_multi(_parent, _args, _info), do: {:ok, []}

  @spec create_via_selected(any, %{atom => any}, %{context: %{token: String.t()}}) :: result()
  def create_via_selected(_parent, args, %{context: %{token: _token}}) do
    args
    |> Spring.create_message()
    |> case do
      {:error, %Ecto.Changeset{}} -> {:ok, []}
      {:ok, struct} ->
        operators = Queries.sorted_by_operators(struct.phone_number)
        case selected_connector(operators, struct.id) do
          [] -> {:ok, struct}
          connector ->
            status = Repo.get_by(Status, %{status_name: connector.status})
            changeset = Message.changeset(struct, %{
              status_id: status.id,
              message_body: "#{struct.message_body} - #{connector.connector}"
            })
            {:ok, _updated} = Repo.update(changeset)
            {:ok, struct}
        end
    end
  end

  @spec create_via_selected(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create_via_selected(_parent, _args, _info), do: {:ok, []}

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

  @spec create_multi(map()) :: {:ok, map()} | {:error, map()}
  defp create_multi(attrs) do
    message_changeset = Message.changeset(%Message{}, attrs)
    Multi.new
    |> Multi.insert(:created, message_changeset)
    |> Multi.run(:sms_logs, fn _, %{created: message} ->
      sms_log_changeset = SmsLog.changeset(%SmsLog{}, %{
        priority: 1,
        messages: message.id,
        statuses: message.status_id
      })
      Repo.insert(sms_log_changeset)
    end)
    |> Multi.run(:sorted, fn _, %{created: message} ->
      operators = Queries.sorted_by_operators(message.phone_number)
      {:ok, operators}
    end)
    |> Multi.run(:connector, fn _, %{sorted: operators, created: message} ->
      connector = selected_connector(operators, message.id)
      {:ok, connector}
    end)
    |> Multi.run(:updated, fn _, %{connector: connector, created: message} ->
      if connector == [] do
        {:ok, message}
      else
        status = Repo.get_by(Status, %{status_name: "delivered"})
        changeset = Message.changeset(message, %{status_id: status.id})
        updated = Repo.update(changeset)
        {:ok, updated}
      end
    end)
    |> Multi.inspect()
    |> Repo.transaction()
    |> case do
      {:ok, %{created: message}} ->
        {:ok, message}
      {:ok, %{sms_logs: sms_log}} ->
        {:ok, sms_log}
      {:ok, %{sorted: sorted}} ->
        {:ok, sorted}
      {:ok, %{connector: connector}} ->
        {:ok, connector}
      {:ok, %{updated: message}} ->
        {:ok, message}
      {:error, _model, changeset, _completed} ->
        {:ok, changeset}
    end
  end

  @spec selected_connector([Operator.t()], String.t()) :: map() | []
  defp selected_connector(operators, message_id) do
    Enum.reduce_while(operators, [], fn(x, acc) ->
      case x.config.name do
        "dia" ->
          case Connector.DiaHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.DiaHandler.get_status(pid) do
                :error ->
                  Connector.DiaHandler.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.DiaHandler.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.DiaHandler.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        "intertelecom" ->
          case Connector.IntertelecomHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.IntertelecomHandler.get_status(pid) do
                :error ->
                  Connector.IntertelecomHandler.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.IntertelecomHandler.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.IntertelecomHandler.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        "kyivstar" ->
          case Connector.KyivstarHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.KyivstarHandler.get_status(pid) do
                :error ->
                  Connector.KyivstarHandler.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.KyivstarHandler.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.KyivstarHandler.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        "lifecell" ->
          case Connector.LifecellHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.LifecellHandler.get_status(pid) do
                :error ->
                  Connector.LifecellHandler.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.LifecellHandler.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.LifecellHandler.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        "telegram" ->
          case Connector.TelegramHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.TelegramHandler.get_status(pid) do
                :error ->
                  Connector.TelegramHandler.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.TelegramHandler.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.TelegramHandler.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        "viber" ->
          case Connector.ViberHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.ViberHandler.get_status(pid) do
                :error ->
                  Connector.ViberHandler.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.ViberHandler.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.ViberHandler.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        "vodafone" ->
          case Connector.VodafoneHandler.start_link([{"#{message_id}"}]) do
            {:ok, pid} ->
              case Connector.VodafoneHandler.get_status(pid) do
                :error ->
                  Connector.VodafoneHandler.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.VodafoneHandler.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.VodafoneHandler.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        _ -> {:cont, acc}
      end
    end)
  end

  @spec by_connector([Operator.t()], Message.t()) :: map() | []
  defp by_connector(operators, struct) do
    Enum.reduce_while(operators, [], fn(x, acc) ->
      case x.config.name do
        "dia" ->
          data = Map.merge(struct, %{connector: "dia"})
          case Connector.HTTPClient.start_link(data) do
            {:ok, pid} ->
              case Connector.HTTPClient.get_state(pid) do
                :error ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.HTTPClient.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        "intertelecom" ->
          data = Map.merge(struct, %{connector: "intertelecom"})
          case Connector.HTTPClient.start_link(data) do
            {:ok, pid} ->
              case Connector.HTTPClient.get_state(pid) do
                :error ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.HTTPClient.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        "kyivstar" ->
          data = Map.merge(struct, %{connector: "kyivstar"})
          case Connector.HTTPClient.start_link(data) do
            {:ok, pid} ->
              case Connector.HTTPClient.get_state(pid) do
                :error ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.HTTPClient.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        "lifecell" ->
          data = Map.merge(struct, %{connector: "lifecell"})
          case Connector.HTTPClient.start_link(data) do
            {:ok, pid} ->
              case Connector.HTTPClient.get_state(pid) do
                :error ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.HTTPClient.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        "telegram" ->
          data = Map.merge(struct, %{connector: "telegram"})
          case Connector.HTTPClient.start_link(data) do
            {:ok, pid} ->
              case Connector.HTTPClient.get_state(pid) do
                :error ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.HTTPClient.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        "viber" ->
          data = Map.merge(struct, %{connector: "viber"})
          case Connector.HTTPClient.start_link(data) do
            {:ok, pid} ->
              case Connector.HTTPClient.get_state(pid) do
                :error ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.HTTPClient.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        "vodafone" ->
          data = Map.merge(struct, %{connector: "vodafone"})
          case Connector.HTTPClient.start_link(data) do
            {:ok, pid} ->
              case Connector.HTTPClient.get_state(pid) do
                :error ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                :timeout ->
                  Connector.HTTPClient.stop(pid)
                  {:cont, acc}
                data ->
                  Connector.HTTPClient.stop(pid)
                  {:halt, data}
              end
            _ -> {:cont, acc}
          end
        _ -> {:cont, acc}
      end
    end)
  end
end
