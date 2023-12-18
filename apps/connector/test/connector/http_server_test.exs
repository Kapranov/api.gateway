defmodule Connector.HTTPServerTest do
  use Connector.DataCase

  alias Connector.TestHTTPServerDelay0, as: Delay0
  alias Connector.TestHTTPServerDelay1, as: Delay1
  alias Connector.TestHTTPServerDelay2, as: Delay2
  alias Connector.TestHTTPServerDelay3, as: Delay3
  alias Connector.TestHTTPServerDelay4, as: Delay4

  @valid_attrs %{connector: providers()}

  describe "HTTPServer as Delay 0 when operator respond without undue delays 10s, 5s, 5s" do
    test "#start_link/1" do
      message = insert(:message, phone_number: "+380997111111")
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      {:ok, pid} = Delay0.start_link(args)

      assert Process.alive?(pid) == true
    end

    test "#get_status/5 when none delay" do
      operator_type = insert(:operator_type)
      config = build(:config, name: @valid_attrs.connector)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)
      config_attrs = Map.from_struct(config)
      attrs = Map.merge(config_attrs, %{parameters: parameters_attrs})
      operator = insert(:operator, operator_type: operator_type, config: attrs)
      status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")
      message = insert(:message, phone_number: "+380997222222", status: status_send)
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      priority = Enum.random(1..9)
      {:ok, _pid} = Delay0.start_link(args)
      result = Delay0.get_status(args.id, priority, status_queue.id, status_expired.id, status_error.id)

      assert operator.config.name           == @valid_attrs.connector
      assert is_atom(result)                != true
      assert result                         != :timeout or :error
      assert result.id                      == message.id
      assert result.status                  != message.status
      assert result.status                  == "delivered"
      assert result.status                  == status_delivered.status_name
      assert result.text                    == message.message_body
      assert result.connector               == @valid_attrs.connector
      assert result.sms                     == message.phone_number
      assert message.status.status_name     == "send"
      assert message.status.description     == "A message was sent to the provider and a positive response was received"
      assert message.status.status_code     == 103
      assert Enum.count(Repo.all(SmsLog))   == 1

      [log1] = logs = Repo.all(SmsLog) |> Repo.preload([
        :operators, statuses: [:messages, :sms_logs],
        messages: [sms_logs: [:messages],
                   status: [:messages, :sms_logs]]])

      assert Enum.count(logs) == 1

      assert log1.messages  |> Enum.count == 1
      assert log1.operators |> Enum.count == 0
      assert log1.statuses  |> Enum.count == 0

      assert log1.messages |> List.last |> Map.get(:id)           == message.id
      assert log1.messages |> List.last |> Map.get(:message_body) == message.message_body
      assert log1.messages |> List.last |> Map.get(:phone_number) == message.phone_number
      assert log1.messages |> List.last |> Map.get(:status_id)    == status_send.id

      assert log1.messages |> List.last |> Map.get(:status) |> Map.get(:description) == status_send.description
      assert log1.messages |> List.last |> Map.get(:status) |> Map.get(:status_name) == status_send.status_name
      assert log1.messages |> List.last |> Map.get(:status) |> Map.get(:status_code) == status_send.status_code
    end

    test "#stop/1" do
      message = insert(:message, phone_number: "+380997333333")
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      {:ok, pid} = Delay0.start_link(args)

      assert Process.alive?(pid) == true

      Process.sleep(1_000)
      Delay0.stop(pid)

      assert Process.alive?(pid) == :ok or :error
    end
  end

  describe "HTTPServer as Delay 1 when operator respond with delay 10s" do
    test "#start_link/1" do
      message = insert(:message, phone_number: "+380997111111")
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      {:ok, pid} = Delay1.start_link(args)

      assert Process.alive?(pid) == true
    end

    test "#get_status/5 when delay 10s" do
      operator_type = insert(:operator_type)
      config = build(:config, name: @valid_attrs.connector)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)
      config_attrs = Map.from_struct(config)
      attrs = Map.merge(config_attrs, %{parameters: parameters_attrs})
      operator = insert(:operator, operator_type: operator_type, config: attrs)
      status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")
      message = insert(:message, phone_number: "+380997222222", status: status_send)
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      priority = Enum.random(1..9)
      {:ok, _pid} = Delay1.start_link(args)
      result = Delay1.get_status(args.id, priority, status_queue.id, status_expired.id, status_error.id)

      assert operator.config.name           == @valid_attrs.connector
      assert is_atom(result)                != true
      assert result                         != :timeout or :error
      assert result.id                      == message.id
      assert result.status                  != message.status
      assert result.status                  == "delivered"
      assert result.status                  == status_delivered.status_name
      assert result.text                    == message.message_body
      assert result.connector               == @valid_attrs.connector
      assert result.sms                     == message.phone_number
      assert message.status.status_name     == "send"
      assert message.status.description     == "A message was sent to the provider and a positive response was received"
      assert message.status.status_code     == 103
      assert Enum.count(Repo.all(SmsLog))   == 2

      [log1, log2] = logs = Repo.all(SmsLog) |> Repo.preload([
        :operators, statuses: [:messages, :sms_logs],
        messages: [sms_logs: [:messages],
                   status: [:messages, :sms_logs]]])

      assert Enum.count(logs) == 2

      assert log1.messages  |> Enum.count == 1
      assert log1.operators |> Enum.count == 0
      assert log1.statuses  |> Enum.count == 0

      assert log2.messages  |> Enum.count == 1
      assert log2.operators |> Enum.count == 0
      assert log2.statuses  |> Enum.count == 1

      assert log1.messages |> List.first |> Map.get(:id)           == message.id
      assert log1.messages |> List.first |> Map.get(:message_body) == message.message_body
      assert log1.messages |> List.first |> Map.get(:phone_number) == message.phone_number
      assert log1.messages |> List.first |> Map.get(:status_id)    == status_send.id

      assert log2.messages |> List.last |> Map.get(:id)           == message.id
      assert log2.messages |> List.last |> Map.get(:message_body) == message.message_body
      assert log2.messages |> List.last |> Map.get(:phone_number) == message.phone_number
      assert log2.messages |> List.last |> Map.get(:status_id)    == status_send.id

      assert log1.messages |> List.first |> Map.get(:status) |> Map.get(:description) == status_send.description
      assert log1.messages |> List.first |> Map.get(:status) |> Map.get(:status_name) == status_send.status_name
      assert log1.messages |> List.first |> Map.get(:status) |> Map.get(:status_code) == status_send.status_code

      assert log2.messages |> List.last |> Map.get(:status) |> Map.get(:description) == status_send.description
      assert log2.messages |> List.last |> Map.get(:status) |> Map.get(:status_name) == status_send.status_name
      assert log2.messages |> List.last |> Map.get(:status) |> Map.get(:status_code) == status_send.status_code
    end

    test "#stop/1" do
      message = insert(:message, phone_number: "+380997333333")
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      {:ok, pid} = Delay1.start_link(args)

      assert Process.alive?(pid) == true

      Process.sleep(1_000)
      Delay1.stop(pid)

      assert Process.alive?(pid) == :ok or :error
    end
  end

  describe "HTTPServer as Delay 2 when operator respond with delay 10s, 5s" do
    test "#start_link/1" do
      message = insert(:message, phone_number: "+380997111111")
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      {:ok, pid} = Delay2.start_link(args)

      assert Process.alive?(pid) == true
    end

    test "#get_status/5 when delay 10s, 5s" do
      operator_type = insert(:operator_type)
      config = build(:config, name: @valid_attrs.connector)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)
      config_attrs = Map.from_struct(config)
      attrs = Map.merge(config_attrs, %{parameters: parameters_attrs})
      operator = insert(:operator, operator_type: operator_type, config: attrs)
      status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")
      message = insert(:message, phone_number: "+380997222222", status: status_send)
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      priority = Enum.random(1..9)
      {:ok, _pid} = Delay2.start_link(args)
      result = Delay2.get_status(args.id, priority, status_queue.id, status_expired.id, status_error.id)

      assert operator.config.name           == @valid_attrs.connector
      assert is_atom(result)                != true
      assert result                         != :timeout or :error
      assert result.id                      == message.id
      assert result.status                  != message.status
      assert result.status                  == "delivered"
      assert result.status                  == status_delivered.status_name
      assert result.text                    == message.message_body
      assert result.connector               == @valid_attrs.connector
      assert result.sms                     == message.phone_number
      assert message.status.status_name     == "send"
      assert message.status.description     == "A message was sent to the provider and a positive response was received"
      assert message.status.status_code     == 103
      assert Enum.count(Repo.all(SmsLog))   == 3

      [log1, log2, log3] = logs = Repo.all(SmsLog) |> Repo.preload([
        :operators, statuses: [:messages, :sms_logs],
        messages: [sms_logs: [:messages],
                   status: [:messages, :sms_logs]]])

      assert Enum.count(logs) == 3

      assert log1.messages  |> Enum.count == 1
      assert log1.operators |> Enum.count == 0
      assert log1.statuses  |> Enum.count == 0

      assert log2.messages  |> Enum.count == 1
      assert log2.operators |> Enum.count == 0
      assert log2.statuses  |> Enum.count == 1

      assert log3.messages  |> Enum.count == 1
      assert log3.operators |> Enum.count == 0
      assert log3.statuses  |> Enum.count == 1

      assert log1.messages |> List.first |> Map.get(:id)           == message.id
      assert log1.messages |> List.first |> Map.get(:message_body) == message.message_body
      assert log1.messages |> List.first |> Map.get(:phone_number) == message.phone_number
      assert log1.messages |> List.first |> Map.get(:status_id)    == status_send.id

      assert log2.messages |> List.first |> Map.get(:id)           == message.id
      assert log2.messages |> List.first |> Map.get(:message_body) == message.message_body
      assert log2.messages |> List.first |> Map.get(:phone_number) == message.phone_number
      assert log2.messages |> List.first |> Map.get(:status_id)    == status_send.id

      assert log3.messages |> List.first |> Map.get(:id)           == message.id
      assert log3.messages |> List.first |> Map.get(:message_body) == message.message_body
      assert log3.messages |> List.first |> Map.get(:phone_number) == message.phone_number
      assert log3.messages |> List.first |> Map.get(:status_id)    == status_send.id

      assert log2.messages |> List.first |> Map.get(:status) |> Map.get(:description) == status_send.description
      assert log2.messages |> List.first |> Map.get(:status) |> Map.get(:status_name) == status_send.status_name
      assert log2.messages |> List.first |> Map.get(:status) |> Map.get(:status_code) == status_send.status_code

      assert log3.messages |> List.first |> Map.get(:status) |> Map.get(:description) == status_send.description
      assert log3.messages |> List.first |> Map.get(:status) |> Map.get(:status_name) == status_send.status_name
      assert log3.messages |> List.first |> Map.get(:status) |> Map.get(:status_code) == status_send.status_code
    end

    test "#stop/1" do
      message = insert(:message, phone_number: "+380997333333")
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      {:ok, pid} = Delay2.start_link(args)

      assert Process.alive?(pid) == true

      Process.sleep(1_000)
      Delay2.stop(pid)

      assert Process.alive?(pid) == :ok or :error
    end
  end

  describe "HTTPServer as Delay 3 when operator respond with delay 10s, 5s, 5s" do
    test "#start_link/1" do
      message = insert(:message, phone_number: "+380997111111")
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      {:ok, pid} = Delay3.start_link(args)

      assert Process.alive?(pid) == true
    end

    test "#get_status/5 when delay 10s, 5s, 5s" do
      operator_type = insert(:operator_type)
      config = build(:config, name: @valid_attrs.connector)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)
      config_attrs = Map.from_struct(config)
      attrs = Map.merge(config_attrs, %{parameters: parameters_attrs})
      operator = insert(:operator, operator_type: operator_type, config: attrs)
      status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")
      message = insert(:message, phone_number: "+380997222222", status: status_send)
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      priority = Enum.random(1..9)
      {:ok, _pid} = Delay3.start_link(args)
      result = Delay3.get_status(args.id, priority, status_queue.id, status_expired.id, status_error.id)

      assert operator.config.name           == @valid_attrs.connector
      assert is_atom(result)                != true
      assert result                         != :timeout or :error
      assert result.id                      == message.id
      assert result.status                  != message.status
      assert result.status                  == "delivered"
      assert result.status                  == status_delivered.status_name
      assert result.text                    == message.message_body
      assert result.connector               == @valid_attrs.connector
      assert result.sms                     == message.phone_number
      assert message.status.status_name     == "send"
      assert message.status.description     == "A message was sent to the provider and a positive response was received"
      assert message.status.status_code     == 103
      assert Enum.count(Repo.all(SmsLog))   == 3

      [log1, log2, log3] = logs = Repo.all(SmsLog) |> Repo.preload([
        :operators, statuses: [:messages, :sms_logs],
        messages: [sms_logs: [:messages],
                   status: [:messages, :sms_logs]]])

      assert Enum.count(logs) == 3

      assert log1.messages  |> Enum.count == 1
      assert log1.operators |> Enum.count == 0
      assert log1.statuses  |> Enum.count == 0

      assert log2.messages  |> Enum.count == 1
      assert log2.operators |> Enum.count == 0
      assert log2.statuses  |> Enum.count == 1

      assert log3.messages  |> Enum.count == 1
      assert log3.operators |> Enum.count == 0
      assert log3.statuses  |> Enum.count == 1

      assert log1.messages |> List.first |> Map.get(:id)           == message.id
      assert log1.messages |> List.first |> Map.get(:message_body) == message.message_body
      assert log1.messages |> List.first |> Map.get(:phone_number) == message.phone_number
      assert log1.messages |> List.first |> Map.get(:status_id)    == status_send.id

      assert log2.messages |> List.first |> Map.get(:id)           == message.id
      assert log2.messages |> List.first |> Map.get(:message_body) == message.message_body
      assert log2.messages |> List.first |> Map.get(:phone_number) == message.phone_number
      assert log2.messages |> List.first |> Map.get(:status_id)    == status_send.id

      assert log3.messages |> List.first |> Map.get(:id)           == message.id
      assert log3.messages |> List.first |> Map.get(:message_body) == message.message_body
      assert log3.messages |> List.first |> Map.get(:phone_number) == message.phone_number
      assert log3.messages |> List.first |> Map.get(:status_id)    == status_send.id

      assert log2.messages |> List.first |> Map.get(:status) |> Map.get(:description) == status_send.description
      assert log2.messages |> List.first |> Map.get(:status) |> Map.get(:status_name) == status_send.status_name
      assert log2.messages |> List.first |> Map.get(:status) |> Map.get(:status_code) == status_send.status_code

      assert log3.messages |> List.first |> Map.get(:status) |> Map.get(:description) == status_send.description
      assert log3.messages |> List.first |> Map.get(:status) |> Map.get(:status_name) == status_send.status_name
      assert log3.messages |> List.first |> Map.get(:status) |> Map.get(:status_code) == status_send.status_code
    end

    test "#stop/1" do
      message = insert(:message, phone_number: "+380997333333")
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      {:ok, pid} = Delay3.start_link(args)

      assert Process.alive?(pid) == true

      Process.sleep(1_000)
      Delay3.stop(pid)

      assert Process.alive?(pid) == :ok or :error
    end
  end

  describe "HTTPServer as Delay 4 when operator respond with delay 10s, 5s, 5s and more" do
    test "#start_link/1" do
      message = insert(:message, phone_number: "+380997111111")
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      {:ok, pid} = Delay4.start_link(args)

      assert Process.alive?(pid) == true
    end

    test "#get_status/5 when delay 10s, 5s, 5s and more" do
      operator_type = insert(:operator_type)
      config = build(:config, name: @valid_attrs.connector)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)
      config_attrs = Map.from_struct(config)
      attrs = Map.merge(config_attrs, %{parameters: parameters_attrs})
      operator = insert(:operator, operator_type: operator_type, config: attrs)
      _status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")
      message = insert(:message, phone_number: "+380997222222", status: status_send)
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      priority = Enum.random(1..9)
      {:ok, _pid} = Delay4.start_link(args)
      result = Delay4.get_status(args.id, priority, status_queue.id, status_expired.id, status_error.id)

      assert operator.config.name           == @valid_attrs.connector
      assert is_atom(result)                == true
      assert result                         == :timeout or :error
      assert message.status.status_name     == "send"
      assert message.status.description     == "A message was sent to the provider and a positive response was received"
      assert message.status.status_code     == 103
      assert Enum.count(Repo.all(SmsLog))   == 4

      [log1, log2, log3, log4] = logs = Repo.all(SmsLog) |> Repo.preload([
        :operators, statuses: [:messages, :sms_logs],
        messages: [sms_logs: [:messages],
                   status: [:messages, :sms_logs]]])

      assert Enum.count(logs) == 4

      assert log1.messages  |> Enum.count == 1
      assert log1.operators |> Enum.count == 0
      assert log1.statuses  |> Enum.count == 0

      assert log2.messages  |> Enum.count == 1
      assert log2.operators |> Enum.count == 0
      assert log2.statuses  |> Enum.count == 1

      assert log3.messages  |> Enum.count == 1
      assert log3.operators |> Enum.count == 0
      assert log3.statuses  |> Enum.count == 1

      assert log4.messages  |> Enum.count == 1
      assert log4.operators |> Enum.count == 0
      assert log4.statuses  |> Enum.count == 1

      assert log1.messages |> List.first |> Map.get(:id)           == message.id
      assert log1.messages |> List.first |> Map.get(:message_body) == message.message_body
      assert log1.messages |> List.first |> Map.get(:phone_number) == message.phone_number
      assert log1.messages |> List.first |> Map.get(:status_id)    == status_send.id

      assert log2.messages |> List.first |> Map.get(:id)           == message.id
      assert log2.messages |> List.first |> Map.get(:message_body) == message.message_body
      assert log2.messages |> List.first |> Map.get(:phone_number) == message.phone_number
      assert log2.messages |> List.first |> Map.get(:status_id)    == status_send.id

      assert log3.messages |> List.first |> Map.get(:id)           == message.id
      assert log3.messages |> List.first |> Map.get(:message_body) == message.message_body
      assert log3.messages |> List.first |> Map.get(:phone_number) == message.phone_number
      assert log3.messages |> List.first |> Map.get(:status_id)    == status_send.id

      assert log4.messages |> List.first |> Map.get(:id)           == message.id
      assert log4.messages |> List.first |> Map.get(:message_body) == message.message_body
      assert log4.messages |> List.first |> Map.get(:phone_number) == message.phone_number
      assert log4.messages |> List.first |> Map.get(:status_id)    == status_send.id

      assert log2.messages |> List.first |> Map.get(:status) |> Map.get(:description) == status_send.description
      assert log2.messages |> List.first |> Map.get(:status) |> Map.get(:status_name) == status_send.status_name
      assert log2.messages |> List.first |> Map.get(:status) |> Map.get(:status_code) == status_send.status_code

      assert log3.messages |> List.first |> Map.get(:status) |> Map.get(:description) == status_send.description
      assert log3.messages |> List.first |> Map.get(:status) |> Map.get(:status_name) == status_send.status_name
      assert log3.messages |> List.first |> Map.get(:status) |> Map.get(:status_code) == status_send.status_code

      assert log4.messages |> List.first |> Map.get(:status) |> Map.get(:description) == status_send.description
      assert log4.messages |> List.first |> Map.get(:status) |> Map.get(:status_name) == status_send.status_name
      assert log4.messages |> List.first |> Map.get(:status) |> Map.get(:status_code) == status_send.status_code
    end

    test "#stop/1" do
      message = insert(:message, phone_number: "+380997333333")
      args = Map.merge(@valid_attrs, %{
        id: message.id,
        message_body: message.message_body,
        phone_number: message.phone_number
      })
      {:ok, pid} = Delay4.start_link(args)

      assert Process.alive?(pid) == true

      Process.sleep(1_000)
      Delay4.stop(pid)

      assert Process.alive?(pid) == :ok or :error
    end
  end
end
