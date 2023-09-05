import Config

config :gateway, Gateway.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "paRBCuqH2XjYKtvZxPrqQX7xfOb7vc8NUmhMStaFs24o82KzfFVz9CC8E9WkLWzB",
  watchers: []

config :gateway, dev_routes: true
