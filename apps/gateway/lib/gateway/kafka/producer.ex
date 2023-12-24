defmodule Gateway.Kafka.Producer do
  @moduledoc false

  require Logger

  @kafka Application.compile_env(:kaffe, :kafka_mod, :brod)
  @report_threshold 40

  @doc """
  Public API

  ## Example.

      iex> Gateway.Kafka.Producer.start_producer_client
      :ok

  """
  @spec start_producer_client() :: :ok
  def start_producer_client do
    @kafka.start_client(config().endpoints, client_name(), config().producer_config)
  end

  @doc """
  Synchronously produce the given `key`/`value` to the first Kafka topic.

  Returns:

      * `:ok` on successfully producing the message
      * `{:error, reason}` for any error

  ## Example.

      iex> key = "AcV6bF6mODc3JIsGf2"
      iex> value = "{\"status\":\"send\",\"text\":\"Ваш код - 7777-999-9999-9999\",\"connector\":\"vodafone\",\"sms\":\"+380997170609\",\"ts\":1703419360268}"
      iex> Gateway.Kafka.Producer.produce_sync(key, value)
      :ok

  """
  @spec produce_sync(any(), any()) :: :ok | tuple()
  def produce_sync(key, value) do
    topic = config().topics |> List.first()
    produce_value(topic, key, value)
  end

  @doc """
  Send attributes of Message by Kafka.

  ## Example.

      iex> Gateway.Kafka.Producer.start_producer_client
      :ok
      iex> args = %{id: "AcV6bF6mODc3JIsGf2", connector: "vodafone", phone_number: "+380997170609", message_body: "Ваш код - 7777-999-9999-9999"}
      iex> Gateway.Kafka.Producer.runner(args)
      :ok

  """
  @spec runner(map()) :: map()
  def runner(args), do: send_message(1, args)

  @spec send_message(integer(), map()) :: :ok
  defp send_message(n, args) do
    key = "#{args.id}"
    t_start = :os.system_time(:milli_seconds)
    value = ~s({"status":"send","text":"#{args.message_body}","connector":"#{args.connector}","sms":"#{args.phone_number}","ts":#{:os.system_time(:milli_seconds)}})

    if n > 0 do
      try do
        produce_sync(key, value)
      rescue
        e -> e
      catch
        e -> e
      after
        t_end = :os.system_time(:milli_seconds)
        t_diff = t_end - t_start
        n = 1
        if t_diff > @report_threshold do
          Logger.log(:info, "Message #{n} Took: #{t_diff}")
        end
        send_message(n - 1, args)
      end
    end
  end

  @spec client_name() :: atom()
  defp client_name do
    config().client_name
  end

  @spec produce_value(String.t(), any(), any()) :: :ok | tuple()
  defp produce_value(topic, key, value) do
    case @kafka.get_partitions_count(client_name(), topic) do
      {:ok, partitions_count} ->
        partition = choose_partition(topic, partitions_count, key, value, global_partition_strategy())
        Logger.debug("event#produce topic=#{topic} key=#{key} partitions_count=#{partitions_count} selected_partition=#{partition}")
        @kafka.produce_sync(client_name(), topic, partition, key, value)
      error ->
        Logger.warning("event#produce topic=#{topic} key=#{key} error=#{inspect(error)}")
        error
    end
  end

  @spec choose_partition(any(), integer(), any(), any(), atom()) :: integer()
  defp choose_partition(_topic, partitions_count, _key, _value, :random) do
    Kaffe.PartitionSelector.random(partitions_count)
  end

  @spec choose_partition(any(), integer(), any(), any(), atom()) :: integer()
  defp choose_partition(_topic, partitions_count, key, _value, :md5) do
    Kaffe.PartitionSelector.md5(key, partitions_count)
  end

  @spec choose_partition(String.t(), integer(), any(), any(), fun()) :: integer()
  defp choose_partition(topic, partitions_count, key, value, fun) when is_function(fun) do
    fun.(topic, partitions_count, key, value)
  end

  @spec global_partition_strategy() :: atom()
  defp global_partition_strategy do
    config().partition_strategy
  end

  @spec config() :: map()
  defp config do
    %{
      endpoints: [{~c"localhost", 9092}],
      topics: ["MyTopic"],
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
