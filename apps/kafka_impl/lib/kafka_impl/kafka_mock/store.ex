defmodule KafkaImpl.KafkaMock.Store do
  @moduledoc false

  @agent_name __MODULE__

  def start_link do
    Agent.start_link(fn -> %{} end, name: @agent_name)
  end

  def get(key, default) do
    get(key, default, self())
  end

  def get(key, default, requesting_pid) do
    case Process.whereis(@agent_name) do
      nil -> default
      _ ->
        Agent.get(@agent_name, fn state ->
          case get_storage_pid(requesting_pid, Map.keys(state)) do
            {:ok, pid} ->
              state
              |> Map.get(pid, %{})
              |> Map.get(key, default)
            _ -> nil
          end
        end)
    end
  end

  def update(func) do
    requesting_pid = self()
    Agent.update(@agent_name, fn state ->
      case get_storage_pid(requesting_pid, Map.keys(state)) do
        {:ok, pid} ->
          Map.update(state, pid, func.(%{}), func)
        _ -> state
      end
    end)
  end

  def register_storage_pid(pid) do
    Agent.update(@agent_name, fn state ->
      Map.put_new(state, pid, %{})
    end)
  end

  def get_storage_pid(child_pid, registered_pids) do
    ancestors = [child_pid | get_ancestors(child_pid)]
    Enum.find(registered_pids, fn registered_pid ->
      Enum.any?(ancestors, & &1 == registered_pid)
    end)
    |> (&{:ok, &1}).()
  end

  defp get_ancestors(pid) do
    case Process.info(pid, [:dictionary]) do
      [dictionary: dictionary] -> Keyword.get(dictionary, :"$ancestors", [])
      _ -> []
    end
  end
end
