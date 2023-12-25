defmodule Connector.Kaffe.MonitorTest do
  use ExUnit.Case, async: true

  alias Connector.Monitor

  setup do
    {:ok, _monitor} = Monitor.start_link([])
    :ok
  end

  describe "Connect to Kafka and consume messages" do
    test "#start_link/1" do
      monitor = Process.whereis(KaffeMonitor)
      data = :sys.get_state(monitor)
      assert {%{}, %{}, _ref, %{}} = data
    end

    test "#up/0" do
      result = Monitor.up()
      assert result == true
    end

    test "#produce/2" do
      id = "Ac7y2LxiD9lsV2Oeiu"
      topic = "MyTopic"
      message = ~s({"status":"send","text":"Ваш код - 7777-999-9999-9999","connector":"kafka","sms":"+380991111111","ts":#{:os.system_time(:milli_seconds)}})
      messages = [%{key: id, value: message}]
      :ok = Monitor.produce(topic, messages)
      %{produce_response: result} = Monitor.set_produce_response(message)
      assert result == message
    end

    test "#set_produce_response/1" do
      pid = Process.whereis(KaffeMonitor)
      message = ~s({"status":"send","text":"Ваш код - 7777-999-9999-9999","connector":"kafka","sms":"+380991111111","ts":#{:os.system_time(:milli_seconds)}})
      :erlang.trace(pid, true, [:receive])
      GenServer.call(pid, {:set_produce_response, message})
      assert_receive {:trace, ^pid, :receive, {:"$gen_call", _, {:set_produce_response, ^message}}}
    end
  end
end
