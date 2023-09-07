Postgrex.Types.define(
  Gateway.PostgresTypes,
  [] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
)
