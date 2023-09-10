import Config

config :gateway, Gateway.Endpoint,
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  phrase: "ouI6a2AWv6BqLYWz57W3ynVzqVuc0niLpimrESGU6S7lUcpc2HqZYI6lxZekbgv8",
  salt: "ksMmovTQMCDHSuGjLSXpRL4uYsqSKKX8PTOl1hVEu1N76WzGqxY5UgucT7bDYggH",
  secret_key_base: "OA0hjIp3fFGYvv8zmyHzJ1g0GtNoEkG1pVQ2NZJIQe0zo3Me54Vts9GGaIzCNM9R",
  url: [scheme: "http", host: "api_gateway.me", port: 4000],
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
  database: "gateway",
  hostname: "localhost",
  password: "nicmos6922",
  pool_size: 10,
  show_sensitive_data_on_connection_error: true,
  username: "kapranov"

config :logger, :console,
  colors: [enabled: true],
  format: "[$date $time] $message\n",
  metadata: [:module, :function, :line]
