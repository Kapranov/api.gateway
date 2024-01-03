defmodule Gateway.Kafka.Consumer do
  @moduledoc """
  Consume messages from Kafka and pass to a given local module.
  """

  alias Core.{
    Monitoring.Status,
    Operators.Operator,
    Queries,
    Repo,
    Spring.Message
  }

  @kafka Application.compile_env(:kaffe, :kafka_mod, :brod)

  @doc """
  Start a Kafka consumer

  ## Example

    iex> {:ok, _pid} = Gateway.Kafka.Consumer.start_link

  """
  @spec start_link() :: {:ok, pid}
  def start_link do
    config = config()

    @kafka.start_link_group_subscriber(
      config.subscriber_name,
      config.consumer_group,
      config.topics,
      config.group_config,
      config.consumer_config,
      __MODULE__,
      [config]
    )
  end

  @spec init(any(), [map()]) :: {:ok, map()}
  def init(_consumer_group, [config]) do
    start_consumer_client(config)
    {:ok, %Kaffe.Consumer.State{message_handler: config.message_handler, async: config.async_message_ack}}
  end

  @doc """
  Call the message handler with the restructured Kafka message.
  """
  @spec handle_messages([%{key: any(), value: any()}]) :: :ok
  def handle_messages(messages) do
    for %{key: key, value: value} = message <- messages do
      data = Jason.decode!(value)
      case Repo.get_by(Message, %{id: key}) do
        nil -> :ok
        struct ->
          operators = Queries.sorted_by_operators(data["sms"])
          case by_connector(operators, struct) do
            [] -> :ok
            connector ->
              status = Repo.get_by(Status, %{status_name: connector.status})
              changeset = Message.changeset(struct, %{
                status_id: status.id,
                message_body: "#{data.text} - #{connector.connector}"
              })
              {:ok, _updated} = Repo.update(changeset)
              :ok
          end
      end
      # credo:disable-for-next-line
      if unquote(Mix.env == :dev), do: IO.inspect message
    end
    :ok
  end

  @spec start_consumer_client(map()) :: :ok
  defp start_consumer_client(config) do
    @kafka.start_client(config.endpoints, config.subscriber_name, config.consumer_config)
  end

  @spec config() :: map()
  defp config do
    %{
      consumer_group: "example-consumer-group",
      endpoints: [{~c"localhost", 9092}],
      message_handler: Gateway.Kafka.Consumer,
      topics: ["MyTopic"],
      max_bytes: 1_000_000,
      max_wait_time: 10_000,
      min_bytes: 0,
      subscriber_name: :"example-consumer-group",
      async_message_ack: false,
      client_down_retry_expire: 30_000,
      consumer_config: [
        auto_start_producers: false,
        allow_topic_auto_creation: false,
        begin_offset: -1
      ],
      group_config: [
        offset_commit_policy: :commit_to_kafka_v2,
        offset_commit_interval_seconds: 5
      ],
      offset_reset_policy: :reset_by_subscriber,
      rebalance_delay_ms: 10_000,
      subscriber_retries: 5,
      subscriber_retry_delay_ms: 5000,
      worker_allocation_strategy: :worker_per_partition
    }
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
