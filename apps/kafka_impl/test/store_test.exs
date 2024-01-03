defmodule KafkaImpl.KafkaMock.StoreTest do
  use ExUnit.Case

  alias KafkaImpl.KafkaMock.Store

  defmodule TestProcess do
    use GenServer

    @name __MODULE__

    def start_link(func \\ (fn -> nil end)) do
      GenServer.start_link(@name, func)
    end

    def init(func) do
      func.()
      {:ok, func}
    end

    def handle_info({:spawn_child, func}, state) do
      {:ok, _} = start_link(func)
      {:noreply, state}
    end
  end

  defp new_link() do
    {:ok, pid} = TestProcess.start_link()
    pid
  end

  test "get_storage_pid for child pid" do
    registered_pids = [
      new_link(),
      storage_pid = new_link(),
      new_link(),
    ]

    test_pid = self()
    send storage_pid, {:spawn_child, fn -> send test_pid, {:child_pid, self()} end}

    child = receive do
      {:child_pid, child} -> child
    after
      1000 -> raise "did not receive child pid after 1s"
    end

    assert {:ok, storage_pid} == Store.get_storage_pid(child, registered_pids)
  end

  test "get_storage_pid for self" do
    registered_pids = [
      new_link(),
      storage_pid = new_link(),
      new_link(),
    ]

    send storage_pid, {:spawn_child, self()}
    send(self(), Store.get_storage_pid(storage_pid, registered_pids))
    assert_received {:ok, _storage_pid}
  end

  test "registering a pid is used for storage" do
    Store.start_link
    Store.register_storage_pid(self())

    parent = new_link()
    test_pid = self()

    send parent, {:spawn_child, fn ->
      Store.update(fn state ->
        Map.put(state, :foo, "bar")
      end)
      send test_pid, :proceed
    end}

    receive do
      :proceed -> :ok
    after
      100 -> raise "didn't get the message to proceed"
    end

    assert "bar" == Store.get(:foo, nil)
  end

  test "get looks up the parent for storage" do
    Store.start_link
    Store.register_storage_pid(self())

    parent = new_link()

    Store.update(fn state ->
      Map.put(state, :foo, "bar")
    end)

    send parent, {:spawn_child, fn ->
      assert "bar" == Store.get(:foo, nil)
    end}
  end

  test "both update and get in children" do
    Store.start_link
    Store.register_storage_pid(self())

    parent1 = new_link()
    test_pid = self()

    send parent1, {:spawn_child, fn ->
      Store.update(fn state ->
        Map.put(state, :foo, "bar")
      end)
      send test_pid, :proceed
    end}

    receive do
      :proceed -> :ok
    after
      100 -> raise "didn't get the message to proceed"
    end

    parent2 = new_link()

    send parent2, {:spawn_child, fn ->
      assert "bar" == Store.get(:foo, nil)
    end}
  end

  test "Store and Kafka in separate trees" do
    parent1 = new_link()
    test_pid = self()

    send parent1, {:spawn_child, fn ->
      Store.start_link
      Store.register_storage_pid(self())
      send test_pid, :proceed1
    end}

    receive do
      :proceed1 -> :ok
    after
      100 -> raise "didn't get the message to proceed"
    end

    parent2 = new_link()

    send parent2, {:spawn_child, fn ->
      Store.update(fn state ->
        Map.put(state, :foo, "bar")
      end)
      send test_pid, :proceed2
    end}

    receive do
      :proceed2 -> :ok
    after
      100 -> raise "didn't get the message to proceed"
    end

    parent3 = new_link()

    send parent3, {:spawn_child, fn ->
      send test_pid, {:message, Store.get(:foo, nil)}
    end}

    assert_receive {:message, "bar"}
  end
end
