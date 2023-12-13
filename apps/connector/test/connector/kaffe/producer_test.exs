defmodule Connector.Kaffe.ProducerTest do
  use ExUnit.Case

  @producer_config Application.compile_env(:kaffe, :producer)

  setup do
    Application.started_applications() |> Enum.any?(fn {app, _, _} -> app == :kaffe end)
    Process.register(self(), :test_case)
    TestBrod.start_link([])
    update_producer_config(:topics, ["topic", "topic2"])
    TestBrod.set_produce_response(:ok)
    :ok
  end

  describe "producer" do
    test "#runner/1" do
      args = %{id: "AcV6bF6mODc3JIsGf2", phone_number: "+380997170609", message_body: "Ваш код - 7777-999-9999-9999"}
      :ok = TestBrod.runner(args)
      assert_receive [:produce_sync, "AcV6bF6mODc3JIsGf2", "+380997170609, Ваш код - 7777-999-9999-9999"]
    end
  end

  defp update_producer_config(key, value) do
    Application.put_env(:kaffe, :producer, put_in(@producer_config, [key], value))
  end
end
