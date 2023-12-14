defmodule Connector.Kaffe.ConsumerTest do
  use ExUnit.Case, async: true

  setup do
    %{
      id: "AcV6bF6mODc3JIsGf2",
      phone_number: "+380997170609",
      message_body: "Ваш код - 7777-999-9999-9999"
    }
  end

  test "kafka messages are into a map", m do
    assert :ok == Connector.handle_messages([m])
  end
end
