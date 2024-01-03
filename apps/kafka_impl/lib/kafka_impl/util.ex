defmodule KafkaImpl.Util do
  @moduledoc false

  def extract_offset([%{partition_offsets: [%{offset: [offset]}]}]), do: {:ok, offset}
  def extract_offset([%{partition_offsets: [%{offset: []}]}]), do: :no_offset
  def extract_offset(error), do: {:error, "Can't extract offset: #{inspect error}"}

  def extract_messages([%{partitions: partitions}]) do
    messages =
      partitions
      |> Enum.map(&(&1[:message_set]))
      |> Enum.reduce([], fn messages, acc ->
        acc ++ messages
      end)

    {:ok, messages}
  end

  def extract_messages(_), do: {:error, "Can't extract messages"}

  def kafka_brokers do
    case Kaffe.Config.Producer.configuration.endpoints() do
      [_] = brokers -> {:ok, brokers}
      _ -> get_brokers_from_default_env_var()
    end
  end

  defp get_brokers_from_default_env_var do
    case System.get_env("KAFKA_URL") do
      nil -> {:error, "You must define KAFKA_HOSTS."}
      hosts -> brokers_parse(hosts)
    end
  end

  defp brokers_parse(brokers_string) do
    Kaffe.Config.parse_endpoints(brokers_string)
    |> (fn brokers -> {:ok, brokers} end).()
  end
end
