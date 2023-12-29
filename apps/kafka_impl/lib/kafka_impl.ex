defmodule KafkaImpl do
  @kafka_impl Application.compile_env!(:kafka_impl, :impl)

  @callback get_metadata(Keyword.t) :: map()
  defdelegate get_metadata(opts \\ []), to: @kafka_impl
  defdelegate resolve_offset(client, topic, partition), to: @kafka_impl
end
