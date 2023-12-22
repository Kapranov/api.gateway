defmodule Gateway.Consumer do
  @moduledoc false

  @kafka Application.compile_env(:kaffe, :kafka_mod, :brod)

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

  def init(_consumer_group, [config]) do
    start_consumer_client(config)
    {:ok, %Kaffe.Consumer.State{message_handler: config.message_handler, async: config.async_message_ack}}
  end

  def start_consumer_client(config) do
    @kafka.start_client(config.endpoints, config.subscriber_name, config.consumer_config)
  end

  defp config do
    %{
      consumer_group: "example-consumer-group",
      endpoints: [{~c"localhost", 9092}],
      message_handler: Gateway,
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
