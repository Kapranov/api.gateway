defmodule Core.MixProject do
  use Mix.Project

  def project do
    [
      app: :core,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: applications(Mix.env),
      mod: {Core.Application, []}
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:logger]
  defp applications(:test), do: applications(:all) ++ [:logger, :faker]
  defp applications(_all), do: [:logger]
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ecto_enum, "~> 1.4"},
      {:ecto_sql, "~> 3.10"},
      {:ex_machina, "~> 2.7"},
      {:ex_unit_notifier, "~> 1.3"},
      {:faker, "~> 0.17", only: [:dev, :test]},
      {:flake_id, "~> 0.1.0"},
      {:jason, "~> 1.4"},
      {:postgrex, "~> 0.17.3"}
    ]
  end

  defp aliases do
    [
      setup: ["ecto.reset"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
