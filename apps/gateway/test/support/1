defmodule ServerWeb.ConnCase do
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
  by setting `use ServerWeb.ConnCase, async: true`, although
  this option is not recommendded for other databases.
  """

  use ExUnit.CaseTemplate

  alias Phoenix.ConnTest
  alias Core.Repo
  alias Ptin.Repo, as: DB
  alias Ecto.Adapters.SQL.Sandbox, as: Adapter

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      import Server.Factory

      use ExSpec

      alias Core.Accounts.User
      alias ServerWeb.Router.Helpers, as: Routes

      @salt Application.compile_env(:server, ServerWeb.Endpoint)[:salt]
      @secret Application.compile_env(:server, ServerWeb.Endpoint)[:secret_key_base]

      @spec auth_conn(Plug.Conn.t(), User.t()) :: Plug.Conn.t()
      def auth_conn(%Plug.Conn{} = conn, %User{} = user) do
        token =
          if is_nil(user), do: nil, else: Phoenix.Token.sign(@secret, @salt, user.id)

        conn
        |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")
        |> Plug.Conn.put_req_header("accept", "application/json")
      end

      @spec auth_conn(Plug.Conn.t(), any()) :: Plug.Conn.t()
      def auth_conn(%Plug.Conn{} = conn, _opts) do
        conn
      end

      @endpoint ServerWeb.Endpoint
    end
  end

  setup tags do
    :ok = Adapter.checkout(Repo) || Adapter.checkout(DB)

    unless tags[:async] do
      Adapter.mode(Repo, {:shared, self()})
      Adapter.mode(DB, {:shared, self()})
    end

    {:ok, conn: ConnTest.build_conn()}
  end
end
