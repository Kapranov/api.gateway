defmodule KafkaImpl.Kaffe do
  @behaviour KafkaImpl

  defdelegate get_metadata(opts), to: :brod
  defdelegate resolve_offset(client, topic, partition), to: :brod

  #def metadata(opts \\ [{"localhost", 9091}]), do: :brod.get_metadata(opts)

  def create_no_name_worker(brokers, consumer_group) do
    create_no_name_worker("0.8.2", brokers, consumer_group)
  end

  def create_no_name_worker(server_module, brokers, consumer_group) when is_atom(server_module) do
    GenServer.start_link(server_module, [
      [uris: brokers, consumer_group: consumer_group],
      :no_name
    ])
  end

  def create_no_name_worker(server_version, brokers, consumer_group) when is_binary(server_version) do
    server_version
    |> KafkaImpl.Util.kaffe_worker
    |> create_no_name_worker(brokers, consumer_group)
  end
end
