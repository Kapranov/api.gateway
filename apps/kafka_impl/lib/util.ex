defmodule KafkaImpl.Util do
  @moduledoc false

  @doc """
  Return the name of the KafkaEx worker for the Kafka version being used.

  ## Example.

      iex> KafkaImpl.Util.kaffe_worker("0.8.2")
      Kaffe.Server0P8P2

  """
  def kaffe_worker(), do: kaffe_worker("0.8.2")
  def kaffe_worker("0.8.0"), do: Kaffe.Server0P8P0
  def kaffe_worker("0.8.2"), do: Kaffe.Server0P8P2
  def kaffe_worker("0.9.0"), do: Kaffe.Server0P9P0
  def kaffe_worker("kayrock"), do: Kaffe.New.Client
  def kaffe_worker(_), do: Kaffe.Server0P10AndLater
end
