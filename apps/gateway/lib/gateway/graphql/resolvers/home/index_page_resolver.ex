defmodule Gateway.GraphQL.Resolvers.Home.IndexPageResolver do
  @moduledoc """
  The Single Page GraphQL resolvers.
  """

  alias Gateway.Endpoint
  alias Phoenix.Token

  @phrase Application.compile_env(:gateway, Endpoint)[:phrase]
  @salt Application.compile_env(:gateway, Endpoint)[:salt]
  @secret Application.compile_env(:gateway, Endpoint)[:secret_key_base]

  @type t :: map
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec public(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def public(_parent, _args, _info) do
    struct = %{status: "working"}
    {:ok, struct}
  end

  @spec index(any, %{atom => any} , %{context: %{token: String.t()}}) :: result()
  def index(_parent, _args, %{context: %{token: token}}) do
    if is_nil(token) do
      {:error, "Permission denied for token to perform action List"}
    else
      struct = %{status: "working"}
      {:ok, struct}
      end
  end

  @spec index(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def index(_parent, _args, _info) do
    struct = %{status: "Unauthenticated"}
    {:ok, struct}
  end

  @spec token(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def token(_parent, _args, _info) do
    with data <- generate_token() do
      {:ok, %{access_token: data}}
    end
  end

  @spec generate_token() :: String.t()
  defp generate_token do
    with {token}  <- Token.sign(@secret, @salt, @phrase) do
      token
    end
  end
end
