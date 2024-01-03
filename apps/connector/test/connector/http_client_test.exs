defmodule Connector.HTTPClientTest do
  @moduledoc false

  use Connector.DataCase

  alias Connector.TestHTTPClientDelay0, as: Delay0
  alias Connector.TestHTTPClientDelay1, as: Delay1
  alias Connector.TestHTTPClientDelay2, as: Delay2
  alias Connector.TestHTTPClientDelay3, as: Delay3
  alias Connector.TestHTTPClientDelay4, as: Delay4

  @valid_attrs %{connector: "vodafone"}
  @invalid_attrs %{id: "AcxjQriQE5ntPrmMJU", connector: "vodafone"}

  describe "HTTPClient" do
    test "#start_link/1 only for args is Struct by `Core.Spring.Message`" do
      _status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      _status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      _status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      _status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      _status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")

      operator_type = insert(:operator_type)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)

      config_vodafone = build(:config, name: "vodafone")
      config_vodafone_attrs = Map.from_struct(config_vodafone)
      vodafone_attrs = Map.merge(config_vodafone_attrs, %{parameters: parameters_attrs})
      _operator_vodafone = insert(:operator, operator_type: operator_type, name_operator: "vodafone", config: vodafone_attrs)
      message = insert(:message, phone_number: "+380997111111")
      args = Map.merge(Map.from_struct(message), @valid_attrs)

      {:ok, pid} = Delay0.start_link(args)

      assert Process.alive?(pid) == true
    end

    test "#get_status/1 only for pid when return completed data - without delays" do
      status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      _status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      _status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      _status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      _status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")

      operator_type = insert(:operator_type)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)

      config_dia = build(:config, name: "dia")
      config_dia_attrs = Map.from_struct(config_dia)
      dia_attrs = Map.merge(config_dia_attrs, %{parameters: parameters_attrs})
      _operator_dia = insert(:operator, operator_type: operator_type, name_operator: "dia", config: dia_attrs)

      config_intertelecom = build(:config, name: "intertelecom")
      config_intertelecom_attrs = Map.from_struct(config_intertelecom)
      intertelecom_attrs = Map.merge(config_intertelecom_attrs, %{parameters: parameters_attrs})
      _operator_intertelecom = insert(:operator, operator_type: operator_type, name_operator: "intertelecom", config: intertelecom_attrs)

      config_kyivstar = build(:config, name: "kyivstar")
      config_kyivstar_attrs = Map.from_struct(config_kyivstar)
      kyivstar_attrs = Map.merge(config_kyivstar_attrs, %{parameters: parameters_attrs})
      _operator_kyivstar = insert(:operator, operator_type: operator_type, name_operator: "kyivstar", config: kyivstar_attrs)

      config_lifecell = build(:config, name: "lifecell")
      config_lifecell_attrs = Map.from_struct(config_lifecell)
      lifecell_attrs = Map.merge(config_lifecell_attrs, %{parameters: parameters_attrs})
      _operator_lifecell = insert(:operator, operator_type: operator_type, name_operator: "lifecell", config: lifecell_attrs)

      config_telegram = build(:config, name: "telegram")
      config_telegram_attrs = Map.from_struct(config_telegram)
      telegram_attrs = Map.merge(config_telegram_attrs, %{parameters: parameters_attrs})
      _operator_telegram = insert(:operator, operator_type: operator_type, name_operator: "telegram", config: telegram_attrs)

      config_viber = build(:config, name: "viber")
      config_viber_attrs = Map.from_struct(config_viber)
      viber_attrs = Map.merge(config_viber_attrs, %{parameters: parameters_attrs})
      _operator_viber = insert(:operator, operator_type: operator_type, name_operator: "viber", config: viber_attrs)

      config_vodafone = build(:config, name: "vodafone")
      config_vodafone_attrs = Map.from_struct(config_vodafone)
      vodafone_attrs = Map.merge(config_vodafone_attrs, %{parameters: parameters_attrs})
      _operator_vodafone = insert(:operator, operator_type: operator_type, name_operator: "vodafone", config: vodafone_attrs)

      message = insert(:message, phone_number: "+380997222222")
      args = Map.merge(Map.from_struct(message), @valid_attrs)

      {:ok, pid} = Delay0.start_link(args)

      result = Delay0.get_state(pid)

      assert is_map(result)   == true
      assert result.id        == message.id
      assert result.status    == status_delivered.status_name
      assert result.text      == message.message_body
      assert result.sms       == message.phone_number
      assert result.connector == @valid_attrs.connector
    end

    test "#get_status/1 only for pid when return is `timeout` - 10s" do
      _status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      _status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      _status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      _status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      _status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")

      operator_type = insert(:operator_type)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)

      config_vodafone = build(:config, name: "vodafone")
      config_vodafone_attrs = Map.from_struct(config_vodafone)
      vodafone_attrs = Map.merge(config_vodafone_attrs, %{parameters: parameters_attrs})
      operator_vodafone = insert(:operator, operator_type: operator_type, name_operator: "vodafone", config: vodafone_attrs)

      message = insert(:message, phone_number: "+380997222222")
      args = Map.merge(Map.from_struct(message), @valid_attrs)

      {:ok, pid} = Delay1.start_link(args)

      result = Delay1.get_state(pid)

      assert operator_vodafone.config.name == @valid_attrs.connector
      assert is_atom(result)               == true
      assert result                        == :timeout
    end

    test "#get_status/1 only for pid when return is `timeout` - 10s, 5s" do
      _status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      _status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      _status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      _status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      _status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")

      operator_type = insert(:operator_type)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)

      config_vodafone = build(:config, name: "vodafone")
      config_vodafone_attrs = Map.from_struct(config_vodafone)
      vodafone_attrs = Map.merge(config_vodafone_attrs, %{parameters: parameters_attrs})
      operator_vodafone = insert(:operator, operator_type: operator_type, name_operator: "vodafone", config: vodafone_attrs)

      message = insert(:message, phone_number: "+380997222222")
      args = Map.merge(Map.from_struct(message), @valid_attrs)

      {:ok, pid} = Delay2.start_link(args)

      result = Delay2.get_state(pid)

      assert operator_vodafone.config.name == @valid_attrs.connector
      assert is_atom(result)               == true
      assert result                        == :timeout
    end

    test "#get_status/1 only for pid when return is `timeout` - 10s, 5s, 5s" do
      _status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      _status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      _status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      _status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      _status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")

      operator_type = insert(:operator_type)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)

      config_vodafone = build(:config, name: "vodafone")
      config_vodafone_attrs = Map.from_struct(config_vodafone)
      vodafone_attrs = Map.merge(config_vodafone_attrs, %{parameters: parameters_attrs})
      operator_vodafone = insert(:operator, operator_type: operator_type, name_operator: "vodafone", config: vodafone_attrs)

      message = insert(:message, phone_number: "+380997222222")
      args = Map.merge(Map.from_struct(message), @valid_attrs)

      {:ok, pid} = Delay3.start_link(args)

      result = Delay3.get_state(pid)

      assert operator_vodafone.config.name == @valid_attrs.connector
      assert is_atom(result)               == true
      assert result                        == :timeout
    end

    test "#get_status/1 only for pid when return is `timeout` - 10s, 5s, 5s and more" do
      _status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      _status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      _status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      _status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      _status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")

      operator_type = insert(:operator_type)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)

      config_vodafone = build(:config, name: "vodafone")
      config_vodafone_attrs = Map.from_struct(config_vodafone)
      vodafone_attrs = Map.merge(config_vodafone_attrs, %{parameters: parameters_attrs})
      operator_vodafone = insert(:operator, operator_type: operator_type, name_operator: "vodafone", config: vodafone_attrs)

      message = insert(:message, phone_number: "+380997222222")
      args = Map.merge(Map.from_struct(message), @valid_attrs)

      {:ok, pid} = Delay4.start_link(args)

      result = Delay4.get_state(pid)

      assert operator_vodafone.config.name == @valid_attrs.connector
      assert is_atom(result)               == true
      assert result                        == :timeout
    end

    test "#get_status/1 only for pid when return is `error` when message doesn't exist" do
      _status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      _status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      _status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      _status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      _status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")

      operator_type = insert(:operator_type)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)

      config_vodafone = build(:config, name: "vodafone")
      config_vodafone_attrs = Map.from_struct(config_vodafone)
      vodafone_attrs = Map.merge(config_vodafone_attrs, %{parameters: parameters_attrs})
      operator_vodafone = insert(:operator, operator_type: operator_type, name_operator: "vodafone", config: vodafone_attrs)

      message = insert(:message, phone_number: "+380997222222")
      args = Map.merge(Map.from_struct(message), @invalid_attrs)

      {:ok, pid} = Delay0.start_link(args)

      result = Delay0.get_state(pid)

      assert operator_vodafone.config.name == @invalid_attrs.connector
      assert is_atom(result)               == true
      assert result                        == :error
    end

    test "#stop/1 only for pid" do
      _status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      _status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      _status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      _status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      _status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")

      operator_type = insert(:operator_type)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)

      config_vodafone = build(:config, name: "vodafone")
      config_vodafone_attrs = Map.from_struct(config_vodafone)
      vodafone_attrs = Map.merge(config_vodafone_attrs, %{parameters: parameters_attrs})
      _operator_vodafone = insert(:operator, operator_type: operator_type, name_operator: "vodafone", config: vodafone_attrs)
      message = insert(:message, phone_number: "+380997333333")
      args = Map.merge(Map.from_struct(message), @valid_attrs)
      {:ok, pid} = Delay0.start_link(args)
      assert Process.alive?(pid) == true
      Process.sleep(1_000)
      Delay0.stop(pid)
      on_exit(fn() ->
        ref = Process.monitor(pid)
        receive  do
          {:DOWN, ^ref, _, _, _} -> :ok
        end
      end)
    end
  end

  describe "HTTPServer uncorrect are attributes" do
    test "#start_link/1 only for args is Struct by `Core.Spring.Message`" do
      _status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      _status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      _status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      _status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      _status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")

      operator_type = insert(:operator_type)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)

      config_vodafone = build(:config, name: "vodafone")
      config_vodafone_attrs = Map.from_struct(config_vodafone)
      vodafone_attrs = Map.merge(config_vodafone_attrs, %{parameters: parameters_attrs})
      _operator_vodafone = insert(:operator, operator_type: operator_type, name_operator: "vodafone", config: vodafone_attrs)
      message = insert(:message, phone_number: "+380997111111")
      args = Map.merge(Map.from_struct(message), %{id: "Ad3y5LGbgYOGCYUGno", connector: "vodafone"})

      {:ok, pid} = Delay0.start_link(args)

      assert Process.alive?(pid) == true
    end

    test "#get_status/1 only for pid when return completed data - without delays" do
      _status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      _status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      _status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      _status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      _status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")

      operator_type = insert(:operator_type)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)

      config_dia = build(:config, name: "dia")
      config_dia_attrs = Map.from_struct(config_dia)
      dia_attrs = Map.merge(config_dia_attrs, %{parameters: parameters_attrs})
      _operator_dia = insert(:operator, operator_type: operator_type, name_operator: "dia", config: dia_attrs)

      config_intertelecom = build(:config, name: "intertelecom")
      config_intertelecom_attrs = Map.from_struct(config_intertelecom)
      intertelecom_attrs = Map.merge(config_intertelecom_attrs, %{parameters: parameters_attrs})
      _operator_intertelecom = insert(:operator, operator_type: operator_type, name_operator: "intertelecom", config: intertelecom_attrs)

      config_kyivstar = build(:config, name: "kyivstar")
      config_kyivstar_attrs = Map.from_struct(config_kyivstar)
      kyivstar_attrs = Map.merge(config_kyivstar_attrs, %{parameters: parameters_attrs})
      _operator_kyivstar = insert(:operator, operator_type: operator_type, name_operator: "kyivstar", config: kyivstar_attrs)

      config_lifecell = build(:config, name: "lifecell")
      config_lifecell_attrs = Map.from_struct(config_lifecell)
      lifecell_attrs = Map.merge(config_lifecell_attrs, %{parameters: parameters_attrs})
      _operator_lifecell = insert(:operator, operator_type: operator_type, name_operator: "lifecell", config: lifecell_attrs)

      config_telegram = build(:config, name: "telegram")
      config_telegram_attrs = Map.from_struct(config_telegram)
      telegram_attrs = Map.merge(config_telegram_attrs, %{parameters: parameters_attrs})
      _operator_telegram = insert(:operator, operator_type: operator_type, name_operator: "telegram", config: telegram_attrs)

      config_viber = build(:config, name: "viber")
      config_viber_attrs = Map.from_struct(config_viber)
      viber_attrs = Map.merge(config_viber_attrs, %{parameters: parameters_attrs})
      _operator_viber = insert(:operator, operator_type: operator_type, name_operator: "viber", config: viber_attrs)

      config_vodafone = build(:config, name: "vodafone")
      config_vodafone_attrs = Map.from_struct(config_vodafone)
      vodafone_attrs = Map.merge(config_vodafone_attrs, %{parameters: parameters_attrs})
      _operator_vodafone = insert(:operator, operator_type: operator_type, name_operator: "vodafone", config: vodafone_attrs)

      message = insert(:message, phone_number: "+380997222222")
      args = Map.merge(Map.from_struct(message), %{id: "Ad3y5LGbgYOGCYUGno", connector: "vodafone"})

      {:ok, pid} = Delay0.start_link(args)

      result = Delay0.get_state(pid)

      assert is_map(result) == false
      assert result         == :error
    end

    test "#stop/1 only for pid" do
      _status_delivered = insert(:status, status_name: "delivered", status_code: 104, description: "provider status when the message is read by the user")
      _status_error = insert(:status, status_name: "error", status_code: 106, description: "sending error")
      _status_expired = insert(:status, status_name: "expired", status_code: 105, description: "timeToLive message expired")
      _status_new = insert(:status, status_name: "new", status_code: 101, description: "new message to send from another system")
      _status_queue = insert(:status, status_name: "queue", status_code: 102, description: "message in queue to be sent")
      _status_send = insert(:status, status_name: "send", status_code: 103, description: "A message was sent to the provider and a positive response was received")

      operator_type = insert(:operator_type)
      parameters = build(:parameters)
      parameters_attrs = Map.from_struct(parameters)

      config_vodafone = build(:config, name: "vodafone")
      config_vodafone_attrs = Map.from_struct(config_vodafone)
      vodafone_attrs = Map.merge(config_vodafone_attrs, %{parameters: parameters_attrs})
      _operator_vodafone = insert(:operator, operator_type: operator_type, name_operator: "vodafone", config: vodafone_attrs)
      message = insert(:message, phone_number: "+380997333333")
      args = Map.merge(Map.from_struct(message), %{id: "Ad3y5LGbgYOGCYUGno", connector: "vodafone"})
      {:ok, pid} = Delay0.start_link(args)
      assert Process.alive?(pid) == true
      Process.sleep(1_000)
      Delay0.stop(pid)
      on_exit(fn() ->
        ref = Process.monitor(pid)
        receive  do
          {:DOWN, ^ref, _, _, _} -> :ok
        end
      end)
    end
  end
end
