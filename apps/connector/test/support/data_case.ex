defmodule Connector.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  alias Core.Repo
  alias Ecto.Adapters.SQL.Sandbox, as: Adapter

  using do
    quote do
      alias Core.Repo
      import Ecto
      import Connector.DataCase
      import Connector.Factory
    end
  end

  setup tags do
    :ok = Adapter.checkout(Repo)
    unless tags[:async], do: Adapter.mode(Repo, {:shared, self()})
    :ok
  end
end
