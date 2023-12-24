defmodule Gateway.Kafka.ProducerTest do
  use Gateway.ConnCase

  alias Gateway.Kafka.Producer

  describe "producer" do
    test "#start_producer_client/0" do
      send(self(), Gateway.Kafka.Producer.start_producer_client)
      assert_receive :ok
    end

    test "#runner/1" do
      message = insert(:message, phone_number: "+380997111111", message_body: "Ваш код - 7777-999-9999-9999")
      args = %{id: message.id, connector: "vodafone", phone_number: message.phone_number, message_body: message.message_body}
      send(self(), Gateway.Kafka.Producer.start_producer_client)
      assert_receive :ok
      send(self(), Producer.runner(args))
      assert_receive :ok
    end

    test "#get current producer's configuration" do
      send(self(), Gateway.Kafka.Producer.start_producer_client)
      assert_receive :ok

      info = Kaffe.Config.Producer.configuration()
      assert info == %{
        endpoints: [{~c"localhost", 9092}],
        topics: ["kaffe-test"],
        client_name: :kaffe_producer_client,
        partition_strategy: :md5,
        producer_config: [
          auto_start_producers: true,
          allow_topic_auto_creation: false,
          default_producer_config: [
            required_acks: -1,
            ack_timeout: 1000,
            partition_buffer_limit: 512,
            partition_onwire_limit: 1,
            max_batch_size: 1048576,
            max_retries: 3,
            retry_backoff_ms: 500,
            compression: :no_compression,
            min_compression_batch_size: 1024
          ]]}
    end
  end
end
