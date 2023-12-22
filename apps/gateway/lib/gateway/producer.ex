defmodule Gateway.Producer do
  @moduledoc false

  require Logger

  @kafka Application.compile_env(:kaffe, :kafka_mod, :brod)
  @report_threshold 40

  def start_producer_client do
    @kafka.start_client(config().endpoints, client_name(), config().producer_config)
  end

  def produce_sync(key, value) do
    topic = config().topics |> List.first()
    produce_value(topic, key, value)
  end

  def runner(args), do: send_message(1, args)

  defp send_message(n, args) do
    key = "#{args.id}"
    t_start = :os.system_time(:milli_seconds)
    value = ~s({"status":"send","text":"#{args.message_body}","connector":"vodafone","sms":"#{args.phone_number}","ts":#{:os.system_time(:milli_seconds)}})

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

  defp client_name do
    config().client_name
  end

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

  defp choose_partition(_topic, partitions_count, _key, _value, :random) do
    Kaffe.PartitionSelector.random(partitions_count)
  end

  defp choose_partition(_topic, partitions_count, key, _value, :md5) do
    Kaffe.PartitionSelector.md5(key, partitions_count)
  end

  defp choose_partition(topic, partitions_count, key, value, fun) when is_function(fun) do
    fun.(topic, partitions_count, key, value)
  end

  defp global_partition_strategy do
    config().partition_strategy
  end

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
