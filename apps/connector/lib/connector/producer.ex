defmodule Connector.Producer do
  @moduledoc """
  Documentation for `Producer` by Kafka.
  """

  @doc """
  Send attributes of Message by Kafka.

  ## Example.

      iex> args = %{id: "AcV6bF6mODc3JIsGf2", phone_number: "+380997170609", message_body: "Ваш код - 7777-999-9999-9999"}
      iex> Connector.Producer.send(args)
      :ok
      iex>[data] = :ets.lookup(:kafka, "AcV6bF6mODc3JIsGf2")
      {"AcV6bF6mODc3JIsGf2", "+380997170609, Ваш код - 7777-999-9999-9999"}
      iex> data |> elem(0)
      "AcV6bF6mODc3JIsGf2"
      iex> data |> elem(1)
      "+380997170609, Ваш код - 7777-999-9999-9999"

      iex> :ets.lookup_element(:kafka, "AcV6bF6mODc3JIsGf2", 1)
      "AcV6bF6mODc3JIsGf2"
      iex> :ets.lookup_element(:kafka, "AcV6bF6mODc3JIsGf2", 2)
      "+380997170609, Ваш код - 7777-999-9999-9999"

      iex> :ets.lookup_element(:kafka, "AcV6bF6mODc3JIsGf2", 2) |> String.split(", ")
      ["+380997170609", "Ваш код - 7777-999-9999-9999"]

      iex> :ets.delete(:kafka, "AcV6bF6mODc3JIsGf2")
      true

  """
  @spec send(map()) :: map()
  def send(args), do: push(args)

  @spec push(map()) :: :ok
  defp push(args) do
    Kaffe.Producer.produce_sync("#{args.id}", "#{args.phone_number}, #{args.message_body}")
  end
end
