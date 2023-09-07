import Config

config :gateway, Gateway.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  url: [scheme: "http", host: "api_gateway.me", port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "paRBCuqH2XjYKtvZxPrqQX7xfOb7vc8NUmhMStaFs24o82KzfFVz9CC8E9WkLWzB",
  watchers: []

config :gateway, dev_routes: true

config :gateway, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: Gateway.Router,
      endpoint: Gateway.Endpoint
    ]
  }

config :phoenix_swagger, json_library: Jason

config :core, Core.Repo,
  username: "kapranov",
  password: "nicmos6922",
  database: "gateway",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :logger, :console,
  format: "[$date $time] $message\n",
  colors: [enabled: true],
  metadata: [:module, :function, :line]
