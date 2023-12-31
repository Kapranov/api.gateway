defmodule Gateway.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Gateway.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL.Sandbox, as: Adapter
  alias Phoenix.ConnTest

  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint Gateway.Endpoint

      use Gateway, :verified_routes

      import Plug.Conn
      import Phoenix.ConnTest
      import Gateway.ConnCase
      import Gateway.DataCase
      import Gateway.Factory

      alias Gateway.Endpoint
      alias Gateway.Router.Helpers, as: Routes

      @salt Application.compile_env(:gateway, Endpoint)[:salt]
      @secret Application.compile_env(:gateway, Endpoint)[:secret_key_base]

      @spec auth_conn(Plug.Conn.t(), String.t()) :: Plug.Conn.t()
      def auth_conn(%Plug.Conn{} = conn, phrase) do
        token =
          if is_nil(phrase), do: nil, else: Phoenix.Token.sign(@secret, @salt, phrase)

        conn
        |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")
        |> Plug.Conn.put_req_header("accept", "application/json")
      end

      @endpoint Endpoint
    end
  end

  setup tags do
    # DataCase.setup_sandbox(tags)
    # {:ok, conn: ConnTest.build_conn()}

    :ok = Adapter.checkout(Repo)

    unless tags[:async] do
      Adapter.mode(Repo, {:shared, self()})
    end

    {:ok, conn: ConnTest.build_conn()}
  end
end
