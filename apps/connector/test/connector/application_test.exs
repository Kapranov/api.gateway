defmodule Connector.ApplicationTest do
  use ExUnit.Case

  test "start code does not crash" do
    started = Application.started_applications()
    assert is_list(started)
    assert {:connector, 'connector', _} = List.keyfind(started, :connector, 0)
  end

  test "returns error when already started" do
    {:error, {:already_started, _pid}} = Connector.Application.start(:normal, [])
  end

  test "application specification" do
    assert is_list(Application.spec(:connector))
    assert Application.spec(:connector, :description) == 'connector'
  end
end
