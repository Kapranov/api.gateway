import Config

case System.cmd "uname", [] do
  {"FreeBSD\n",0} -> nil
  {"Darwin\n", 0} -> nil
  {"Linux\n", 0} ->
    config :ex_unit_notifier,
    notifier: ExUnitNotifier.Notifiers.NotifySend
  _other -> nil
end

config :gateway, Gateway.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "99CqfpOMyjmG9+iNQWIxjaLpSNsec7wbrZlwkKvA1WEJt8U5OntFWnh7sbjJN6Cl",
  server: false

config :core, Core.Repo,
  database: "gateway_test",
  hostname: "localhost",
  password: "nicmos6922",
  pool: Ecto.Adapters.SQL.Sandbox,
  show_sensitive_data_on_connection_error: true,
  username: "kapranov"

config :logger, level: :warning
