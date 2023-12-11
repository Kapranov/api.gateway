defmodule Connector.MixProject do
  use Mix.Project

  def project do
    [
      app: :connector,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :kaffe],
      mod: {Connector.Application, []}
    ]
  end

  defp deps do
    [
      {:core, in_umbrella: true},
      {:cowboy, "~> 2.10"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.30", only: :dev, runtime: false},
      {:excoveralls, "~> 0.17", only: :test},
      {:gen_state_machine, "~> 3.0"},
      {:hackney, "~> 1.20"},
      {:honeybadger, "~> 0.21.0"},
      {:httpoison, "~> 2.1"},
      {:inch_ex, "~> 2.0", only: [:dev, :test]},
      {:jason, "~> 1.4"},
      {:kaffe, "~> 1.24"},
      {:murmur, "~> 1.0"},
      {:plug, "~> 1.15"},
      {:plug_cowboy, "~> 2.6"},
      {:tesla, "~> 1.8"},
      {:uuid, "~> 1.1"},
      {:wormhole, "~> 2.3"}
    ]
  end
end
