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
  http: [ port: 4001, protocol_options: [idle_timeout: 160_000]],
  live_view: [signing_salt: "W871n4Ux"],
  max_age: 300 * 24 * 3600,
  pubsub_server: Gateway.PubSub,
  redirect_uri: "http://192.168.2.157:4000/graphiql",
  render_errors: [ formats: [json: Gateway.ErrorJSON], layout: false ],
  url: [host: "159.224.174.183", port: 80, ip: {192, 168, 2, 157}],
  version: Mix.Project.config()[:version]

config :gateway,
  generators: [context_app: false]

config :logger, :console,
  colors: [ enabled: true, debug: :cyan, info: :green, warn: :yellow, error: :red ],
  format: "$time $metadata[$level] $message\n",
  level: level,
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :ex_json_schema,
  :remote_schema_resolver,
  fn url -> HTTPoison.get!(url).body |> Jason.decode! end

config :core, ecto_repos: [Core.Repo]

config :absinthe_error_payload,
  ecto_repos: [Core.Repo],
  field_constructor: AbsintheErrorPayload.FieldConstructor

config :tesla, adapter: Tesla.Adapter.Hackney

config :kaffe,
  consumer: [
    endpoints: [localhost: 9092],
    topics: ["MyTopic"],
    consumer_group: "example-consumer-group",
    message_handler: Connector
  ],
  producer: [
    endpoints: [localhost: 9092],
    topics: ["MyTopic"]
  ]

import_config "#{config_env()}.exs"
