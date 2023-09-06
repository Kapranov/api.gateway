defmodule Gateway.DataCase do
  @moduledoc false

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(_tags) do
    :ok
    # pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Core.Repo, shared: not tags[:async])
    # on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end
end
