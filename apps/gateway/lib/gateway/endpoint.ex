defmodule Gateway.Endpoint do
  use Phoenix.Endpoint, otp_app: :gateway
  use Absinthe.Phoenix.Endpoint

  alias Absinthe.Plug.Parser, as: AbsintheParser
  alias Phoenix.CodeReloader

  alias Plug.{
    Head,
    MethodOverride,
    Parsers,
    RequestId,
    Session,
    Telemetry
  }

  alias Gateway.Router

  @session_options [
    store: :cookie,
    key: "_gateway_key",
    signing_salt: "pnQCi2+s",
    same_site: "Lax"
  ]

  plug Plug.Static,
    at: "/",
    from: :gateway,
    gzip: false,
    only: Gateway.static_paths()

  if code_reloading? do
    plug CodeReloader
  end

  plug RequestId
  plug Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Parsers,
    parsers: [:urlencoded, {:multipart, length: 10_000_000}, :json, AbsintheParser],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug MethodOverride
  plug Head
  plug Session, @session_options
  plug CORSPlug
  plug Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  @spec init(any(), %{atom => any}) :: {:ok, any()}
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
