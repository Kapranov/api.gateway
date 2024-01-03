defmodule KafkaImpl.KafkaMock do
  @moduledoc false

  @behaviour KafkaImpl

  alias KafkaImpl.KafkaMock.Store

  @host Application.compile_env(:kaffe, :producer)[:endpoints] |> Keyword.keys |> List.last |> to_string
  @port Application.compile_env(:kaffe, :producer)[:endpoints] |> Keyword.values |> List.last
  @endpoint [{@host, @port}]
  @endpoints Application.compile_env(:kaffe, :producer)[:endpoints]
  @client :kafka_client

  defdelegate start_link, to: Store

  def start_client(endpoints \\ @endpoints, client \\ @client) do
    :ok = :brod.start_client(endpoints, client, auto_start_producers: true)
  end

  def get_metadata(hosts \\ @endpoint) do
    {:ok, data} = :brod.get_metadata(hosts)
    %{topic_metadatas: Enum.map(data.topics, &(&1.name))}
  end

  def get_producer(client, topic, partition) do
    {:ok, producer_id} = :brod.get_producer(client, topic, partition)
    %{producer_id: producer_id}
  end

  def produce(%{topic: topic, partition: partition, messages: [%{key: _key, value: _value} = message]}, _opts \\ []) do
    Store.update(fn state ->
      key = messages_key(topic, partition)
      existing_records = Map.get(state, key, [])
      offset = Enum.reduce(existing_records, -1, fn %{offset: offset}, acc ->
        if offset > acc, do: offset, else: acc
      end) + 1
      record = %{
        value: message.value,
        offset: offset
      }

      state
      |> Map.put(key, [record | existing_records])
    end)
  end

  def produce(pid, key, value) do
    {:ok, data} = :brod.produce(pid, key, value)
    data
  end

  def produce(client, topic, partition, key, value) do
    {:ok, _data} = :brod.produce(client, topic, partition, key, value)
    Store.update(fn state ->
      key = messages_key(topic, partition)
      existing_records = Map.get(state, key, [])
      offset = Enum.reduce(existing_records, -1, fn %{offset: offset}, acc ->
        if offset > acc, do: offset, else: acc
      end) + 1
      record = %{value: value, offset: offset}
      state
      |> Map.put(key, [record | existing_records])
    end)
  end

  def resolve_offset(hosts, topic, partition) do
    {:ok, num} = :brod.resolve_offset(hosts, topic, partition)
    num
  end

  def resolve_offset(hosts, topic, partition, time) do
    {:ok, num} = :brod.resolve_offset(hosts, topic, partition, time)
    num
  end


  def fetch(hosts, topic, partition, offset) do
    {:ok, data} = :brod.fetch(hosts, topic, partition, offset)
    data
  end

  def fetch(hosts, topic, partition, offset, opts) do
    {:ok, data} = :brod.fetch(hosts, topic, partition, offset, opts)
    data
  end

  def fetch_committed_offsets(client, group_id) do
    case :brod.fetch_committed_offsets(client, group_id) do
      {:ok, []} -> %{topic: nil, partition: []}
      {:ok, [record]} ->
        consumer_group = group_id
        topic = record.name
        partition = List.last(record.partitions).partition_index
        offset = List.last(record.partitions).committed_offset
        Store.update(fn state ->
          Map.put(state, {:offset_commit, consumer_group, topic, partition}, offset)
        end)
        %{topic: topic, partitions: [offset]}
    end
  end

  def metadata(opts \\ []) do
    topics = Store.get(:topics, opts)
    %{topic_metadatas: topics}
  end

  def create_no_name_worker(_server_module \\ nil, _brokers, _consumer_group) do
    {:ok, :fake_pid}
  end

  def latest_offset(_client, _topic, _partition) do
    [%{
      partition_offsets: [%{offset: [0]}]
    }]
  end

  def earliest_offset(_client, _topic, _partition) do
    %{partition_offsets: [%{offset: [-100]}]}
  end

  def offset_fetch(_pid, topic, partition) do
    %{partitions: [
      %{
        error_code: :no_error,
        metadata: "",
        offset: 1,
        partition: partition
      }],
      topic: topic
    }
  end

  def fetch(topic, partition, opts \\ []) do
    offset = Keyword.get(opts, :offset, 0)
    message_set =
      messages_key(topic, partition)
      |> Store.get([])
      |> Enum.filter(fn %{offset: msg_offset} -> msg_offset >= offset end)

    last_offset = Enum.reduce(message_set, nil, fn %{offset: msg_offset}, acc ->
      cond do
        acc == nil -> msg_offset
        acc > msg_offset -> acc
        true -> msg_offset
      end
    end)
    [%{
      topic: topic,
      partitions: [%{
        partition: partition,
        message_set: message_set,
        last_offset: last_offset
      }]
    }]
  end

  def offset(_topic, _partition, time, _client) do
    offset = Store.get({:offset_at, time}, 0)
    %{offset: [offset]}
  end

  def offset_commit(_worker, %{consumer_group: consumer_group, topic: topic, partition: partition, offset: offset}) do
    Store.update(fn state ->
      Map.put(state, {:offset_commit, consumer_group, topic, partition}, offset)
    end)
    %{topic: topic, partitions: [offset]}
  end

  @spec random_uint64() :: integer()
  def random_uint64 do
    :crypto.strong_rand_bytes(8)
    |> :binary.decode_unsigned()
  end

  @spec unix_time() :: integer()
  def unix_time do
    DateTime.utc_now()
    |> DateTime.to_unix()
  end

  defp messages_key(topic, partition) do
    {:produce, topic, partition}
  end
end
