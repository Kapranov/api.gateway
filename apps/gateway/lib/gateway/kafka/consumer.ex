defmodule Gateway.Kafka.Consumer do
  @moduledoc """
  Consume messages from Kafka and pass to a given local module.
  """

  @connector :kafka
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

  @spec init(any(), [map()]) :: {:ok, %Kaffe.Consumer.State{}}
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
      case is_list(:ets.info(@connector)) do
        true ->
          try do
            :ets.insert(@connector, {key, value})
          rescue
            ArgumentError ->
              IO.inspect message
          end
        false ->
          :ets.new(@connector, [:set, :public, :named_table])
          :ets.insert(@connector, {key, value})
      end
      IO.inspect message
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
      max_bytes: 1000000,
      max_wait_time: 10000,
      min_bytes: 0,
      subscriber_name: :"example-consumer-group",
      async_message_ack: false,
      client_down_retry_expire: 30000,
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
      rebalance_delay_ms: 10000,
      subscriber_retries: 5,
      subscriber_retry_delay_ms: 5000,
      worker_allocation_strategy: :worker_per_partition
    }
  end
end
