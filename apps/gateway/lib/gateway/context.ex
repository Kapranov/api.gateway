defmodule Gateway.Context do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn

  alias Absinthe.Plug
  alias Gateway.Endpoint
  alias Phoenix.Token

  @type opts :: [context: map]

  @max_age Application.compile_env(:gateway, Endpoint)[:max_age]
  @salt Application.compile_env(:gateway, Endpoint)[:salt]
  @secret Application.compile_env(:gateway, Endpoint)[:secret_key_base]

  @spec init(opts :: opts()) :: map()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _) do
    context = build_context(conn)
    Plug.put_options(conn, context: context)
  end

  @doc """
  Return an empty map context based on the authorization header
  """
  @spec build_context(Plug.Conn.t()) :: %{token: User.t()} | map()
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
      {:ok, phrase} <- authorize(token) do
        %{token: phrase}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    case Token.verify(@secret, @salt, token, max_age: @max_age) do
      {:error, :invalid} ->
        {:error, "invalid authorization token"}
      {:error, :expired} ->
        {:error, "token has been expired or revoked"}
      {:ok, phrase} ->
        {:ok, phrase}
    end
  end
end
