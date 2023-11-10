import Config

config :gateway, Gateway.Endpoint,
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  http: [ip: {192, 168, 2, 145}, port: 4000],
  phrase: "ouI6a2AWv6BqLYWz57W3ynVzqVuc0niLpimrESGU6S7lUcpc2HqZYI6lxZekbgv8",
  salt: "ksMmovTQMCDHSuGjLSXpRL4uYsqSKKX8PTOl1hVEu1N76WzGqxY5UgucT7bDYggH",
  secret_key_base: "OA0hjIp3fFGYvv8zmyHzJ1g0GtNoEkG1pVQ2NZJIQe0zo3Me54Vts9GGaIzCNM9R",
  url: [scheme: "http", host: "159.224.174.183", port: 4000],
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

config :providers, :dia,
  adapter: HTTPoison,
  body: "",
  header: "application/json",
  token: "WZTB25QSB25dHxBxCaH86Xe6Jd3dP4LhInrWZKS2ew5Yt8888888888888888888",
  url: "https://api2t.diia.gov.ua/api/v2/auth/partner",
  url_push: "https://api2t.diia.gov.ua/api/v1/notification/distribution/push",
  url_template: "https://api2t.diia.gov.ua/api/v1/notification/template"

config :logger, :console,
  colors: [enabled: true],
  format: "[$date $time] $message\n",
  metadata: [:module, :function, :line]
