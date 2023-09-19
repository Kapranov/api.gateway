pg_bench_url = System.get_env("PG_URL") || "postgres:postgres@localhost"

Application.put_env(
  :ecto_sql,
  Core.Bench.Repo,
  url: "ecto://" <> pg_bench_url <> "/ecto_test",
  adapter: Ecto.Adapters.Postgres,
  show_sensitive_data_on_connection_error: true
)

defmodule Core.Bench.Repo do
  use Core.Repo, otp_app: :core, adapter: Ecto.Adapters.Postgres, log: false
end
