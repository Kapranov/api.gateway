defmodule KafkaImpl.Kaffe do
  @moduledoc false

  @behaviour KafkaImpl

  defdelegate fetch(client, topic, partition, offset), to: :brod
  defdelegate fetch(client, topic, partition, offset, opts), to: :brod
  defdelegate fetch_committed_offsets(client, group_id), to: :brod
  defdelegate get_metadata(hosts), to: :brod
  defdelegate get_producer(client, topic, partition), to: :brod
  defdelegate produce(producer_id, value), to: :brod
  defdelegate produce(producer_id, key, value), to: :brod
  defdelegate produce(client, topic, partition, key, value), to: :brod
  defdelegate resolve_offset(hosts, topic, partition), to: :brod
  defdelegate resolve_offset(hosts, topic, partition, time), to: :brod
  defdelegate start_client(endpoints, client), to: :brod
end
