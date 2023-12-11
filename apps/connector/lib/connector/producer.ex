defmodule Connector.Producer do
  @moduledoc """
  Documentation for `Producer` by Kafka.
  """

  require Logger

  @report_threshold 40

  @doc """
  Send attributes of Message by Kafka.

  ## Example.

      iex> args = %{id: "AcV6bF6mODc3JIsGf2", phone_number: "+380997170609", message_body: "Ваш код - 7777-999-9999-9999"}
      iex> Connector.Producer.send(1, args)
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

      iex> key = ""
      iex> value = ~s({"a":"#{UUID.uuid4()}","timestamp":#{:os.system_time(:milli_seconds)},"c":"aBcDeFgHiJk","d":"This is a test","e":"#{UUID.uuid4()}","f":"testing"})
      iex> value = ~s({"id":"Ac7y2LxiD9lsV2Oeiu","status":"send","text":"Ваш код - 7777-999-9999-9999 - vodafone","connector":"vodafone","sms":"+380991111111","timestamp":#{:os.system_time(:milli_seconds)}})
      iex> value |> Jason.decode!
      iex> id = "Ac7y2LxiD9lsV2Oeiu"
      iex> messages = ~s({"status":"send","text":"Ваш код - 7777-999-9999-9999 - vodafone","connector":"vodafone","sms":"+380991111111"})
      iex> Kaffe.Producer.produce_sync(id, messages)
      iex> run_start = :os.system_time(:milli_seconds)
      iex> KaffeTestProducer.runner(messages_count)
      iex> run_end = :os.system_time(:milli_seconds)
      iex> messages_sec = (messages_count / (run_end - run_start))*1000

  """
  @spec runner(map()) :: map()
  def runner(args), do: send_message(1, args)

  @spec send_message(integer(), map()) :: :ok
  defp send_message(n, args) do
    t_start = :os.system_time(:milli_seconds)

    if n > 0 do
      try do
        Kaffe.Producer.produce_sync("#{args.id}", "#{args.phone_number}, #{args.message_body}")
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
end
