defmodule Connector.Monitor do
  @moduledoc """
  This module allows you to connect to Kafka and consume messages
  without crashing your app when Kafka goes offline. In the event
  of a Kafka outage it will attempt to reconnect once a minute.
  """

  use GenServer

  require Logger

  @brokers Application.compile_env(:kaffe, :producer)[:endpoints]
  @client_name :kaffe_producer_client
  @kafka Application.compile_env(:kaffe, :kafka_mod, :brod)
  @name __MODULE__
  @none "none"
  @restart_wait_seconds 60

  def start_link(opts \\ []) do
    GenServer.start_link(@name, opts, name: KaffeMonitor)
  end

  def up do
    Application.started_applications() |> Enum.any?(fn {app, _, _} -> app == :kaffe end)
  end

  def produce(topic, messages) when is_binary(topic) and is_list(messages) do
    unless length(messages) <= 0 do
      if KaffeMonitor |> GenServer.call({:produce, topic, messages}) == :error do
        Logger.warning("Kaffe failed to produce messages to #{topic}. Waiting #{@restart_wait_seconds} seconds and trying again.")
        Process.sleep(@restart_wait_seconds * 1000)
        produce(topic, messages)
      end
    end
  end

  @impl true
  def init(child_specs) do
    Application.ensure_started(:connector)
    children = Map.new
    refs = Map.new
    worker_ref = nil
    partition_counts = Map.new

    Supervisor.start_link(
      [{DynamicSupervisor, name: Connector.Monitor.DynamicSupervisor, strategy: :one_for_one}],
      strategy: :one_for_one,
      name: Connector.Monitor.Supervisor
    )

    Process.send(self(), :start_worker, [])

    case System.get_env("KAFKA_URL") do
      nil -> nil
      value ->
        brokers =
          value
          |> String.replace("kafka+ssl://", "")
          |> String.replace("kafka://", "")
          |> String.split(",")
          |> Enum.map(fn endpoint ->
            [ip, port] = endpoint |> String.split(":")
            {ip |> String.to_charlist(), port |> String.to_integer()}
          end)

        Application.put_env(:kaffe, :producer, endpoints: brokers)
    end

    Logger.debug("Kaffe using brokers: " <> inspect(@brokers))

    for child_spec <- child_specs do
      Process.send(self(), {:start_child, child_spec}, [])
    end

    {:ok, {children, refs, worker_ref, partition_counts}}
  end

  @impl true
  def handle_info(:start_worker, {children, refs, worker_ref, partition_counts}) do
    Application.start(:kaffe)

    worker_ref =
      case Kaffe.GroupMemberSupervisor.start_link() do
        {:ok, pid} ->
          Logger.info("Monitoring Kaffe worker at " <> inspect(pid))
          Process.monitor(pid)
        {:error, {:already_started, pid}} ->
          Logger.info("Kaffe worker already running at " <> inspect(pid))
          Process.monitor(pid)
        {:error, error} ->
          Logger.warning("Kaffe.GroupMemberSupervisor failed to start #{inspect(error)}. Restarting in #{@restart_wait_seconds} seconds...")
          Process.send_after(self(), :start_link, @restart_wait_seconds * 1000)
          worker_ref
      end

    {:noreply, {children, refs, worker_ref, partition_counts}}
  end

  @impl true
  def handle_info({:start_child, child_spec}, {children, refs, worker_ref, partition_counts}) do
    Application.start(:kaffe)

    {children, refs, worker_ref, partition_counts} =
      case DynamicSupervisor.start_child(Connector.Monitor.DynamicSupervisor, child_spec) do
        {:ok, pid} ->
          Logger.info("Kaffe monitoring #{inspect(child_spec)} at #{inspect(pid)}")
          ref = Process.monitor(pid)
          refs = Map.put(refs, ref, child_spec)
          children = Map.put(children, child_spec, pid)
          {children, refs, worker_ref, partition_counts}
        {:error, error} ->
          Logger.warning("Kaffe #{inspect(child_spec)} failed to start #{inspect(error)}. Restarting in #{@restart_wait_seconds} seconds...")
          Process.send_after(self(), {:start_child, child_spec}, @restart_wait_seconds * 1000)
          {children, refs, worker_ref, partition_counts}
      end
    {:noreply, {children, refs, worker_ref, partition_counts}}
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {children, refs, worker_ref, partition_counts}) do
    if ref == worker_ref do
      Logger.warning("Kaffe worker went down. Restarting in #{@restart_wait_seconds} seconds...")
      Process.send_after(self(), :start_worker, @restart_wait_seconds * 1000)
      {:noreply, {children, refs, worker_ref, partition_counts}}
    else
      {child_spec, refs} = Map.pop(refs, ref)
      children = Map.delete(children, child_spec)
      Logger.warning("Kaffe #{inspect(child_spec)} went down. Restarting in #{@restart_wait_seconds} seconds...")
      Process.send_after(self(), {:start_child, child_spec}, @restart_wait_seconds * 1000)
      {:noreply, {children, refs, worker_ref, partition_counts}}
    end
  end

  @impl true
  @spec handle_call({atom(), String.t(), [%{key: String.t(), value: String.t()}]}, any(), {map(), map(), nil, map()}) :: tuple()
  def handle_call({:produce, topic, messages}, _from, {children, refs, worker_ref, partition_counts}) do
    unless worker_ref != nil && Application.started_applications() |> Enum.any?(fn {app, _, _} -> app == :kaffe end) do
      Logger.error("Kaffe is down and unable to produce messages to topic #{topic}")
      {:reply, :error, {children, refs, worker_ref, partition_counts}}
    else
      partition_counts =
        case partition_counts |> Map.has_key?(topic) do
          true -> partition_counts
          false -> partition_counts |> Map.put(topic, get_partition_count(topic))
        end

      messages_by_parition =
        messages
        |> Enum.reduce(%{}, fn message, map ->
          partition =
            case Map.has_key?(message, :key) && !is_nil(message.key) do
              true -> rem(Murmur.hash_x86_32(message.key), partition_counts[topic])
              false -> Enum.random(0..(partition_counts[topic] - 1))
            end
          Map.put(map, partition, Map.get(map, partition, []) ++ [message])
        end)

      Logger.debug("Kaffe producing to topic: #{topic} partitions #{inspect(Map.keys(messages_by_parition))}")

      for partition <- messages_by_parition |> Map.keys() do
        messages =
          messages_by_parition[partition]
            |> Enum.map(fn message ->
              case Map.has_key?(message, :key) && !is_nil(message.key) do
                true ->
                  case @kafka.produce_sync(@client_name, topic, partition, message.key, message.value) do
                    :ok ->
                      data =
                        message.value
                        |> Jason.decode!
                        |> Map.put("id", message.key)

                      %{
                        connector: data["connector"],
                        id: message.key,
                        sms: data["sms"],
                        status: data["status"],
                        text: data["text"],
                        ts: data["ts"]
                      }
                    _ -> Map.new
                  end
                false ->
                  case @kafka.produce_sync(@client_name, topic, partition, @none, message.value) do
                    :ok ->
                      data =
                        message.value
                        |> Jason.decode!
                        |> Map.put("id", @none)

                      %{
                        connector: data["connector"],
                        id: @none,
                        sms: data["sms"],
                        status: data["status"],
                        text: data["text"],
                        ts: data["ts"]
                      }
                    _ -> Map.new
                  end
              end
          end)

        [payload] = messages
        Logger.debug("Kaffe producing payload #{inspect(payload)}")
        produce_with_retry(payload)
      end
      {:reply, :ok, {children, refs, worker_ref, partition_counts}}
    end
  end

  defp get_partition_count(topic) when is_binary(topic) do
    {:ok, counts} = :brod.get_partitions_count(@client_name, topic)
    counts
  end

  defp produce_with_retry(payload) do
    key = payload.id
    value = ~s({"status":"#{payload.status}","text":"#{payload.text}","connector":"#{payload.connector}","sms":"#{payload.sms}","ts":#{payload.ts}})
    result =
      Wormhole.capture(
        fn ->
          Logger.debug("success")
#          case Kaffe.Producer.produce_sync(key, value) do
#            :ok -> Logger.debug("success")
#            {:ok, _} -> Logger.debug("success")
#          end
        end,
        retry_count: 5,
        backoff_ms: 1_000
      )
    case result do
      {:error, error} ->
        Logger.error("Kaffe error #{inspect(error)} while producing kafka message #{inspect(payload)}")
        Honeybadger.notify(error)
      _ -> nil
    end
  end
end
