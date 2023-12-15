defmodule Connector.UtilsTest do
  use ExUnit.Case

  alias Connector.Utils

  test "#random_state/0" do
    data = Utils.random_state()
    assert data == :ok or :error
  end

  test "#transfer/1" do
    message = ~s({"id":"AcpTkVJz5lcdU4nzxA","sms":"+380991111111","status":"send","text":"Hello World!"})
    body = %{"data" => message}
    result = Utils.transfer(body["data"])
    assert result == %{"id" => "AcpTkVJz5lcdU4nzxA", "status" => "send"}
  end

  test "random_timer/0" do
    number = Utils.random_timer()
    assert is_integer(number) == true
  end

  test "random_timer/1" do
    n = 1..3
    number = Utils.random_timer(n)
    assert is_integer(number) == true
  end

  test "#while/2" do
    n = Enum.random(0..9)
    m = Enum.random(1..3_000)
    result = Connector.Utils.while(fn -> n end, m)
    assert is_atom(result) == true
    assert result == :timeout
  end
end
