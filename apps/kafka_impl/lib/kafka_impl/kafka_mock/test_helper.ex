defmodule KafkaImpl.KafkaMock.TestHelper do
  @moduledoc false

  alias KafkaImpl.KafkaMock.Store

  def set_topics(new_topics) do
    Store.update(fn state ->
      Map.put(state, :topics, new_topics |> Enum.map(&format_for_kaffe/1))
    end)
  end

  def send_messages(topic, partition, [%{} | _] = messages) do
    Store.update(fn state ->
      Map.put(state, {:produce, topic, partition}, messages)
    end)
  end

  def read_messages(topic, partition) do
    Store.get({:produce, topic, partition}, [])
    |> Enum.map(fn %{value: msg} -> msg end)
  end

  defp format_for_kaffe({topic_name, number_of_partitions}) do
    %{
      error_code: 0,
      partition_metadatas: Enum.map(1..number_of_partitions, fn n ->
        %{
          error_code: 0,
          isrs: [0],
          leader: 0,
          partition_id: n,
          replicas: [0]
        }
      end),
      topic: topic_name
    }
  end

  defp format_for_kaffe(topic_name) when is_binary(topic_name) do
    format_for_kaffe({topic_name, 1})
  end
end
