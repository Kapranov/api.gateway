defmodule Gateway.Endpoint do
  use Phoenix.Endpoint, otp_app: :gateway

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
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug Gateway.Router
end
