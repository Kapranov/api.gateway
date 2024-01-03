defmodule Gateway.Kafka.ConsumerTest do
  use Gateway.ConnCase

  alias Gateway.Kafka.Consumer
  alias Gateway.Kafka.Producer

  setup do
    %{
      id: "AcV6bF6mODc3JIsGf2",
      connector: "vodafone",
      phone_number: "+380997111111",
      message_body: "Ваш код - 7777-999-9999-9999"
    }
  end

  describe "consumer" do
    test "#start_link/0" do
      send(self(), Consumer.start_link)
      assert_receive {:ok, pid}
      data = :sys.get_state(pid)
      assert {
        :state,
        :"example-consumer-group",
        _ref,
        "example-consumer-group",
        :undefined,
        :undefined,
        _pid,
        [],
        [
          auto_start_producers: false,
          allow_topic_auto_creation: false,
          begin_offset: -1
        ],
        true,
        :undefined,
        Consumer,
        %Kaffe.Consumer.State{
          message_handler: Consumer,
          async: false
        },
        :message} = data
    end

    test "#handle_messages/1", m do
      message = insert(:message, phone_number: "+380997111111", message_body: "Ваш код - 7777-999-9999-9999")
      args = %{id: message.id, connector: "vodafone", phone_number: message.phone_number, message_body: message.message_body}
      send(self(), Producer.start_producer_client)
      assert_receive :ok
      send(self(), Producer.runner(args))
      assert_receive :ok
      assert :ok == Consumer.handle_messages([m])
    end

    test "#get current consumer's configuration" do
      {:ok, _pid} = Gateway.Kafka.Consumer.start_link
      info = Kaffe.Config.Consumer.configuration()
      assert info == %{
        async_message_ack: false,
        client_down_retry_expire: 15_000,
        consumer_config: [
          auto_start_producers: false,
          allow_topic_auto_creation: false,
          begin_offset: :earliest
        ],
        consumer_group: "kaffe-test-group",
        endpoints: [{~c"localhost", 9_092}],
        group_config: [
          offset_commit_policy: :commit_to_kafka_v2,
          offset_commit_interval_seconds: 5
        ],
        max_bytes: 10_000,
        max_wait_time: 10_000,
        message_handler: SilentMessage,
        min_bytes: 0,
        offset_reset_policy: :reset_by_subscriber,
        rebalance_delay_ms: 100,
        subscriber_name: :"kaffe-test-group",
        subscriber_retries: 5,
        subscriber_retry_delay_ms: 5_000,
        topics: ["kaffe-test"],
        worker_allocation_strategy: :worker_per_partition
      }
    end
  end
end
