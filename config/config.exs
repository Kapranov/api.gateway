import Config

config :gateway,
  ecto_repos: [Gateway.Repo],
  generators: [context_app: false]

# Configures the endpoint
config :gateway, Gateway.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: Gateway.ErrorJSON],
    layout: false
  ],
  pubsub_server: Gateway.PubSub,
  live_view: [signing_salt: "W871n4Ux"]

config :gateway,
  generators: [context_app: false]

# Configures the endpoint
config :gateway, Gateway.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: Gateway.ErrorJSON],
    layout: false
  ],
  pubsub_server: Gateway.PubSub,
  live_view: [signing_salt: "j+yMPMOH"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
