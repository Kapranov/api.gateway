defmodule Connector.MetaPidTest do
  use ExUnit.Case

  doctest Connector.MetaPid

  import ExUnit.CaptureLog

  alias Connector.MetaPid

  defmodule MyTestStruct do
    defstruct [:foo, xs: MapSet.new]
  end

  defmodule MetaPidSomeStruct do
    use MetaPid, into: MyTestStruct, name: :meta_pid
  end

  defmodule TestProcess do
    use GenServer

    @name __MODULE__

    def start_link() do
      GenServer.start_link(@name, nil)
    end

    def init(nil), do: {:ok, nil}

    def handle_info({:spawn_child, from}, state) do
      {:ok, child_pid} = start_link()
      send from, {:child_pid, child_pid}
      {:noreply, state}
    end
  end

  defp new_link() do
    {:ok, pid} = TestProcess.start_link()
    pid
  end

  setup do
    {:ok, pid} = MetaPidSomeStruct.start_link()
    %{server: pid}
  end

  test "server is registered under the name specified when using the macro", %{server: pid} do
    assert Process.whereis(:meta_pid) == pid
  end

  test "stopping kills the process", %{server: pid} do
    assert Process.alive?(pid)
    MetaPidSomeStruct.stop()
    refute Process.alive?(pid)
  end

  test "initializes an empty map for the registry" do
    assert MetaPidSomeStruct.get_registry() == Map.new
  end

  test "adds a new pid to the registry" do
    pid = new_link()
    MetaPidSomeStruct.register_pid(pid)
    assert Map.has_key?(MetaPidSomeStruct.get_registry(), pid)
  end

  test "removes a pid from the registry" do
    pids = Enum.map(0..10, fn (_) -> new_link() end)

    pids
    |> Enum.each(fn(pid) -> MetaPidSomeStruct.register_pid(pid) end)

    [to_remove | remaining] = pids

    MetaPidSomeStruct.unregister_pid(to_remove)
    assert (MetaPidSomeStruct.get_registry() |> Map.keys) == remaining
  end

  test "a pid's data can be retrieved once registered" do
    pid = new_link()

    assert :error == MetaPidSomeStruct.fetch_pid(pid)

    MetaPidSomeStruct.register_pid(pid)

    assert {:ok, _} = MetaPidSomeStruct.fetch_pid(pid)
  end

  test "pid registered without data is initialized to an empty struct bound to the MetaPid" do
    pid = new_link()

    MetaPidSomeStruct.register_pid(pid)

    assert {:ok, %MyTestStruct{}} == MetaPidSomeStruct.fetch_pid(pid)
  end

  test "a pid can be optionally registered with data" do
    pid = new_link()

    my_data = %MyTestStruct{foo: :bar}

    MetaPidSomeStruct.register_pid(pid, my_data)

    assert MetaPidSomeStruct.fetch_pid(pid) == {:ok, my_data}
  end

  test "allows updates of data for a pid" do
    pids     = Enum.map(0..10, fn (_) -> new_link() end)
    data     = %MyTestStruct{foo: :bar}
    new_data = %MyTestStruct{foo: :new_value}

    pids |> Enum.each(fn (pid) -> MetaPidSomeStruct.register_pid(pid, data) end)

    [to_change | remaining] = pids

    MetaPidSomeStruct.put_pid(to_change, new_data)

    remaining |> Enum.each(fn (pid) ->
      assert MetaPidSomeStruct.fetch_pid(pid) == {:ok, data}
    end)

    assert MetaPidSomeStruct.fetch_pid(to_change) == {:ok, new_data}
  end

  test "can update an existing structure by passing a function" do
    self() |> MetaPidSomeStruct.register_pid
    self() |> MetaPidSomeStruct.transform_pid(fn (existing) ->
      %MyTestStruct{existing | xs: MapSet.put(existing.xs, 1)}
    end)

    {:ok, actual} = self() |> MetaPidSomeStruct.fetch_pid

    assert actual == %MyTestStruct{xs: MapSet.new([1])}
  end

  test "can update a pid concurrently" do
    registered = self()

    MetaPidSomeStruct.register_pid(registered)

    tasks = Enum.map(0..10, fn (n) ->
      Task.async(fn () ->
        MetaPidSomeStruct.transform_pid(registered, fn (existing) ->
          %MyTestStruct{ existing | xs: MapSet.put(existing.xs, n) }
        end)
      end)
    end)

    _ = tasks |> Task.yield_many()

    {:ok, actual} = MetaPidSomeStruct.fetch_pid(registered)

    expected = %MyTestStruct{xs: MapSet.new(Enum.map(0..10, fn (n) -> n end))}

    assert actual == expected
  end

  test "when a process dies, its key is removed from the registry" do
    pids = Enum.map(0..10, fn (_) ->
      spawn(fn -> :timer.sleep(1) end)
    end)

    pids |> Enum.each(&MetaPidSomeStruct.register_pid/1)

    :timer.sleep(10)

    assert MetaPidSomeStruct.get_registry() == %{}
  end

  test "pid is automatically unregistered if it dies as a consequence of a runtime error" do
    capture_log(fn ->
      test_process = self()

      spawn(fn () ->
        spawn_link(fn () ->
          send(test_process, self())
          receive do
            _ -> nil
          end
          raise ArithmeticError, message: "intentionally fail"
        end)
      end)

      pid = receive do
        spawned_process -> spawned_process
      end

      MetaPidSomeStruct.register_pid(pid)

      send pid, :die_now

      Enum.reduce_while(1..100, 0, fn _, acc ->
        case MetaPidSomeStruct.fetch_pid(pid) do
          :error -> {:halt, acc}
          _ ->
            Process.sleep(2)
            {:cont, acc}
        end
      end)

      assert :error == MetaPidSomeStruct.fetch_pid(pid)
    end)
  end

  test "pid is automatically unregistered if its process terminates before callback is set" do
    pid = spawn(fn () ->
      receive do
        _ -> nil
      end
    end)

    Process.exit(pid, :kill)

    MetaPidSomeStruct.register_pid(pid)

    :timer.sleep(1)

    assert :error == MetaPidSomeStruct.fetch_pid(pid)
  end

  test "a pid's ancestor's data can be retrieved" do
    pid = new_link()

    send pid, {:spawn_child, self()}

    child_pid = receive do
      {:child_pid, pid} -> pid
    after
      100 -> :error
    end

    assert child_pid != :error

    assert :error == MetaPidSomeStruct.fetch_pid(child_pid)

    MetaPidSomeStruct.register_pid(pid)

    assert {:ok, _} = MetaPidSomeStruct.fetch_pid(child_pid)
  end
end
