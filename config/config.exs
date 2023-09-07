import Config

elixir_logger_level = System.get_env("ELIXIR_LOGGER_LEVEL") || "info"

level =
  case String.downcase(elixir_logger_level) do
    s when s == "1" or s == "debug" ->
      :debug
    s when s == "3" or s == "warn" ->
      :warn
    _ ->
      :info
  end

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

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: level,
  colors: [
    enabled: true,
    debug: :cyan,
    info: :green,
    warn: :yellow,
    error: :red
  ]

config :phoenix, :json_library, Jason

config :ex_json_schema,
  :remote_schema_resolver,
  fn url -> HTTPoison.get!(url).body |> Jason.decode! end

config :core, ecto_repos: [Core.Repo]

import_config "#{config_env()}.exs"
