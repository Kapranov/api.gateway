defmodule Connector.HTTPServerTest do
  use Connector.DataCase

  alias Connector.HTTPServer

  @valid_attrs %{connector: "vodafone"}

  describe "HTTPServer" do
    test "#start_link/1" do
      message = insert(:message)
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      {:ok, pid} = HTTPServer.start_link(args)
      assert Process.alive?(pid) == true
    end

    test "#get_status/5 return `delivered`" do
    end

    test "#get_status/5 return `timeout`" do
      status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      message = insert(:message)
      sms_logs = insert(:sms_log, %{
        messages: [message],
        statuses: [message.status]
      })
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      priority = Enum.random(1..9)
      {:ok, _pid} = HTTPServer.start_link(args)
      result = HTTPServer.get_status(args.id, priority, status_queue.id, status_expired.id, status_error.id)
      assert is_atom(result) == true
      assert result == :timeout
      assert message.status.status_name == "send"
      assert message.status.description == "A message was sent to the provider and a positive response was received"
      assert message.status.status_code == 103
      assert sms_logs.priority == 1
      assert Enum.count(sms_logs.messages) == 1
      assert Enum.count(Core.Repo.all(Core.Logs.SmsLog)) == 5
    end

    test "#get_status/5 return `error`" do
    end

    test "#get_status/5 return `nil`" do
    end

    test "#stop/1" do
      message = insert(:message)
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      {:ok, pid} = HTTPServer.start_link(args)
      assert Process.alive?(pid) == true
      Process.sleep(1_000)
      HTTPServer.stop(pid)
      assert Process.alive?(pid) == :ok or :error
    end
  end
end
