defmodule KafkaImpl do
  @moduledoc false

  @type earliest() :: integer()
  @type endpoint() :: {String.t(), integer()}
  @type error() :: {atom(), []} | {atom(), atom()}
  @type hostname() :: atom()
  @type latest() :: integer()
  @type max_bytes() :: non_neg_integer()
  @type max_wait_time() :: pos_integer()
  @type min_bytes() :: non_neg_integer()
  @type msg_ts() :: integer() | earliest() | latest()
  @type portnum() :: integer()

  @kafka_impl Application.compile_env!(:kafka_impl, :impl)
  @callback fetch([{String.t(), integer()}], String.t(), integer(), integer()) :: {:ok, {integer(), list()}}
  defdelegate fetch(hosts, topic, partition, offset), to: @kafka_impl
  @callback fetch([{String.t(), integer()}], String.t(), integer(), integer(), %{String.t() => max_bytes() | min_bytes() | max_wait_time()}) :: {:ok, {integer(), list()}}
  defdelegate fetch(hosts, topic, partition, offset, opts), to: @kafka_impl
  @callback fetch_committed_offsets(atom(), String.t()) :: {:ok, [map()]} | {error, any()}
  defdelegate fetch_committed_offsets(client, group_id), to: @kafka_impl
  @callback get_metadata([endpoint()]) :: {:ok, map()} | {error, any()}
  defdelegate get_metadata(hosts \\ []), to: @kafka_impl
  @callback get_producer(atom(), String.t(), integer()) :: {:ok, pid} | {error, any()}
  defdelegate get_producer(client, topic, partition), to: @kafka_impl
  @callback produce(pid(), list()) :: {:ok, reference()} | {error, any()}
  defdelegate produce(producer_id, value), to: @kafka_impl
  @callback produce(pid(), String.t(), list()) :: {:ok, reference()} | {error, any()}
  defdelegate produce(producer_id, key, value), to: @kafka_impl
  @callback produce(atom(), String.t(), integer(), String.t(), String.t() | list()) :: {:ok, reference()} | {error, any()}
  defdelegate produce(client, topic, partition, key, value), to: @kafka_impl
  @callback resolve_offset([endpoint()], String.t(), integer()) :: {:ok, integer()} | {error, any()}
  defdelegate resolve_offset(hosts, topic, partition), to: @kafka_impl
  @callback resolve_offset([endpoint()], String.t(), integer(), msg_ts()) :: {:ok, integer()} | {error, any()}
  defdelegate resolve_offset(hosts, topic, partition, time), to: @kafka_impl
  @callback start_client([{hostname(), portnum()}], atom()) :: :ok | {error, any()}
  defdelegate start_client(endpoints, client), to: @kafka_impl
end
