defmodule Connector.LifecellHandlerTest do
  use Connector.DataCase

  alias Connector.LifecellHandler

  describe "LifecellHandler" do
    test "#start_link/1" do
      message = insert(:message, phone_number: "+380997111111")
      {:ok, pid} = LifecellHandler.start_link([{"#{message.id}"}])
      assert Process.alive?(pid) == true
    end

    test "#get_status/1" do
      message = insert(:message, phone_number: "+380997111111")
      {:ok, pid} = LifecellHandler.start_link([{"#{message.id}"}])
      data = LifecellHandler.get_status(pid)
      if data == :timeout do
        assert is_atom(data) == true
        assert data          == :timeout
      else
        assert is_atom(data)  != true
        assert data.connector == "lifecell"
        assert data.id        == message.id
        assert data.sms       == message.phone_number
        assert data.status    == "delivered"
        assert data.text      == message.message_body
      end
    end

    test "#stop/1" do
      message = insert(:message, phone_number: "+380997111111")
      {:ok, pid} = LifecellHandler.start_link([{"#{message.id}"}])
      assert Process.alive?(pid) == true
      Process.sleep(1_000)
      LifecellHandler.stop(pid)
      on_exit(fn() ->
        ref = Process.monitor(pid)
        receive  do
          {:DOWN, ^ref, _, _, _} -> :ok
        end
      end)
    end
  end
end
