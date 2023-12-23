defmodule Gateway.MixProject do
  use Mix.Project

  def project do
    [
      app: :gateway,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Gateway.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:absinthe, "~> 1.7"},
      {:absinthe_auth, "~> 0.2.1"},
      {:absinthe_error_payload, "~> 1.1", override: true},
      {:absinthe_phoenix, "~> 2.0", override: true},
      {:absinthe_plug, "~> 1.5", override: true},
      {:absinthe_relay, "~> 1.5", override: true},
      {:connector, in_umbrella: true},
      {:core, in_umbrella: true},
      {:cors_plug, "~> 3.0"},
      {:dataloader, "~> 2.0"},
      {:ex_json_schema, "~> 0.7.1"},
      {:ex_machina, "~> 2.7"},
      {:ex_spec, "~> 2.0", only: [:test]},
      {:ex_unit_notifier, "~> 1.3"},
      {:faker, "~> 0.17", only: [:dev, :test]},
      {:gen_state_machine, "~> 3.0"},
      {:jason, "~> 1.2"},
      {:observer_cli, "~> 1.7"},
      {:phoenix, "~> 1.7.7"},
      {:phoenix_swagger, "~> 0.8.3"},
      {:plug_cowboy, "~> 2.5"},
      {:providers, in_umbrella: true},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get"]
    ]
  end
end
