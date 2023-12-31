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
  phrase: "EJxpuX8PD1sNYnr15Sr5rsQSUCcXcZnwuV9FZJKE0TL+uNE/nmBfBXZsdJ9ngs5q",
  salt: "Tqo8gY+TfKOJIWMYdFyobEHi/ueQoICGCAuN2qXijAv6due3kMb5dcYDoC1Ons6s",
  secret_key_base: "99CqfpOMyjmG9+iNQWIxjaLpSNsec7wbrZlwkKvA1WEJt8U5OntFWnh7sbjJN6Cl",
  server: false

config :core, Core.Repo,
  database: "gateway_test",
  hostname: "localhost",
  password: "nicmos6922",
  pool: Ecto.Adapters.SQL.Sandbox,
  show_sensitive_data_on_connection_error: true,
  username: "kapranov"

config :providers, :dia,
  adapter: HTTPoison,
  body: "",
  header: "application/json",
  token: "WZTB25QSB25dHxBxCaH86Xe6Jd3dP4LhInrWZKS2ew5Yt4w2SCxMyvPAG8X3ffI8",
  url: "https://api2t.diia.gov.ua/api/v2/auth/partner"

config :kaffe,
  kafka_mod: :brod,
  test_partition_count: 32,
  consumer: [
    async_message_ack: false,
    client_down_retry_expire: 15_000,
    consumer_group: "kaffe-test-group",
    endpoints: [localhost: 9092],
    max_bytes: 10_000,
    message_handler: SilentMessage,
    rebalance_delay_ms: 100,
    ssl: false,
    start_with_earliest_message: true,
    topics: ["kaffe-test"]
  ],
  producer: [
    endpoints: [localhost: 9092],
    ssl: false,
    topics: ["kaffe-test"]
  ]

config :kafka_impl, :impl, KafkaImpl.KafkaMock

config :logger, level: :warning
