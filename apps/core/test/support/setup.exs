Code.require_file("repo.exs", __DIR__)
Code.require_file("migrations.exs", __DIR__)
Code.require_file("schemas.exs", __DIR__)

alias Core.Bench.{Repo, CreateSetting}

{:ok, _} = Ecto.Adapters.Postgres.ensure_all_started(Repo.config(), :temporary)

_ = Ecto.Adapters.Postgres.storage_down(Repo.config())
:ok = Ecto.Adapters.Postgres.storage_up(Repo.config())

{:ok, _pid} = Repo.start_link(log: false)

:ok = Ecto.Migrator.up(Repo, 0, CreateSetting, log: false)
