defmodule Connector.Producer do
  @moduledoc """
  Documentation for `Producer` by Kafka.
  """

  require Logger

  @connector "kafka"
  @report_threshold 40

  @doc """
  Send attributes of Message by Kafka.

  ## Example.

      iex> args = %{id: "AcV6bF6mODc3JIsGf2", phone_number: "+380997170609", message_body: "Ваш код - 7777-999-9999-9999"}
      iex> Connector.Producer.runner(args)
      :ok
      iex>[data] = :ets.lookup(:kafka, "AcV6bF6mODc3JIsGf2")
      [{"AcV6bF6mODc3JIsGf2", "{\"status\":\"send\",\"text\":\"Ваш код - 7777-999-9999-9999\",\"connector\":\"kafka\",\"sms\":\"+380997170609\",\"ts\":1702542761151}"}]
      iex> data |> elem(0)
      "AcV6bF6mODc3JIsGf2"
      iex> data |> elem(1)
      "{\"status\":\"send\",\"text\":\"Ваш код - 7777-999-9999-9999\",\"connector\":\"kafka\",\"sms\":\"+380997170609\",\"ts\":1702542761151}"

      iex> :ets.lookup_element(:kafka, "AcV6bF6mODc3JIsGf2", 1)
      "AcV6bF6mODc3JIsGf2"
      iex> :ets.lookup_element(:kafka, "AcV6bF6mODc3JIsGf2", 2)
      "{\"status\":\"send\",\"text\":\"Ваш код - 7777-999-9999-9999\",\"connector\":\"kafka\",\"sms\":\"+380997170609\",\"ts\":1702542761151}"

      iex> :ets.lookup_element(:kafka, "AcV6bF6mODc3JIsGf2", 2) |> String.split(", ")
      ["{\"status\":\"send\",\"text\":\"Ваш код - 7777-999-9999-9999\",\"connector\":\"kafka\",\"sms\":\"+380997170609\",\"ts\":1702542761151}"]

      iex> :ets.delete(:kafka, "AcV6bF6mODc3JIsGf2")
      true

  """
  @spec runner(map()) :: map()
  def runner(args), do: send_message(1, args)

  @spec send_message(integer(), map()) :: :ok
  defp send_message(n, args) do
    key = "#{args.id}"
    t_start = :os.system_time(:milli_seconds)
    value = ~s({"status":"send","text":"#{args.message_body}","connector":"#{@connector}","sms":"#{args.phone_number}","ts":#{:os.system_time(:milli_seconds)}})

    if n > 0 do
      try do
        Kaffe.Producer.produce_sync(key, value)
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
