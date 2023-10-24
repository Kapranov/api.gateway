defmodule Providers.MixProject do
  use Mix.Project

  def project do
    [
      app: :providers,
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
      extra_applications: [:logger],
      mod: {Providers.Application, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 2.1"},
      {:jason, "~> 1.4"},
      {:mimic, "~> 1.7", only: :test},
      {:mock, "~> 0.3.8", only: :test},
      {:mox, "~> 1.1", only: :test},
      {:plug, "~> 1.15"}
    ]
  end
end
