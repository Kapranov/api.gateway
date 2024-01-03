defmodule KafkaImpl.UtilTest do
  use ExUnit.Case, async: true

  doctest KafkaImpl.Util

  alias KafkaImpl.Util

  describe ".extract_offset()" do
    test "unwraps the offset embedded in the response" do
      example_response = [%{
        partition_offsets: [%{
          error_code: 0,
          offset: [1_008],
          partition: 0
        }],
        topic: "test"
      }]

      assert Util.extract_offset(example_response) == {:ok, 1008}
    end
  end

  describe "extract messages" do
    test "unwraps fetched messages" do
      messages = [
        %{
          attributes: 0,
          crc: 3_546_726_102,
          key: nil,
          offset: 1_005,
          value: "test message 1000"
        },
        %{
          attributes: 0,
          crc: 4_251_893_211,
          key: nil,
          offset: 1_006,
          value: "hi"
        },
        %{
          attributes: 0,
          crc: 4_253_201_296,
          key: nil,
          offset: 1_007,
          value: "boo"
        }
      ]

      raw_data = [
        %{
          partitions: [%{
            error_code:     0,
            hw_mark_offset: 1_008,
            last_offset:    1_007,
            message_set:    messages,
            partition:      0
          }],
          topic: "test"
        }
      ]

      assert Util.extract_messages(raw_data) == {:ok, messages}
    end

    test "brokers_parse" do
      assert {:ok, [{~c"localhost", 9_092}]} == Util.kafka_brokers
    end
  end
end
