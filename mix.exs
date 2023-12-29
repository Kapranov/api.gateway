defmodule GatewayApi.MixProject do
  use Mix.Project

  @version "0.0.1-beta.1"

  def project do
    [
      aliases: aliases(),
      apps_path: "apps",
      deps: deps(),
      description: description(),
      docs: docs(),
      elixirc_options: [warnings_as_errors: warnings_as_errors(Mix.env())],
      homepage_url: "https://api.gateway.com.ua/",
      name: "APIGateway",
      preferred_cli_env: cli_env_for(:test, [
        "coveralls", "coveralls.detail", "coveralls.post",
        "coveralls.html", "coveralls.json", "test.reset"
      ]),
      source_url: "https://github.com/kapranov/api_gateway",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      updated: update_version(@version),
      version: version(@version)
    ]
  end

  defp aliases do
    [
      bless: [&bless/1],
      "deps.get": [
        "deps.get",
        &update_version/1
      ],
      "test.cover": &run_default_coverage/1,
      "test.cover.html": &run_html_coverage/1,
      "test.no.start": ["test --no-start"],
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.30.6", runtime: false},
      {:ex_spec, "~> 2.0", only: [:test]},
      {:ex_unit_notifier, "~> 1.3", [env: :prod, hex: "ex_unit_notifier", repo: "hexpm"]},
      {:excoveralls, "~> 0.17.1", only: [:test]},
      {:junit_formatter, "~> 3.3"},
      {:mix_test_watch, "~> 1.1", only: [:test], runtime: false}
    ]
  end

  defp description do
    contents = "An easy way to manage GraphQL Channel and much more for eHealth Inc. Kyiv"
    Mix.shell().info("Synopsis version with: #{inspect(contents)}")
  end

  defp docs do
    [
      name: "APIGateway",
      source_url: "https://github.com/kapranov/api_gateway",
      homepage_url: "htts://api.gateway.me:4001/docs",
      docs: [
        main: "APIGateway",
        logo: "",
        extras: ["README.md"]
      ]
    ]
  end

  defp cli_env_for(env, tasks) do
    Enum.reduce(tasks, [], fn(key, acc) -> Keyword.put(acc, :"#{key}", env) end)
  end

  defp warnings_as_errors(:prod), do: false
  defp warnings_as_errors(_), do: true

  defp update_version(_) do
    contents = [
      version(@version),
      get_commit_sha(),
      get_commit_date()
    ]

    Mix.shell().info("Updating version with: #{inspect(contents)}")
    File.write("VERSION", Enum.join(contents, "\n"), [:write])
  end

  defp version(version) do
    identifier_filter = ~r/[^0-9a-z\-]+/i

    git_pre_release =
      with {tag, 0} <-
           System.cmd("git", ["describe", "--tags", "--abbrev=0"], stderr_to_stdout: true),
           {describe, 0} <- System.cmd("git", ["describe", "--tags", "--abbrev=8"]) do
        describe
        |> String.trim()
        |> String.replace(String.trim(tag), "")
        |> String.trim_leading("-")
        |> String.trim()
      else
        _ ->
          {commit_hash, 0} = System.cmd("git", ["rev-parse", "--short", "HEAD"])
          "0-g" <> String.trim(commit_hash)
      end

    branch_name =
      with {branch_name, 0} <- System.cmd("git", ["rev-parse", "--abbrev-ref", "HEAD"]),
           branch_name <- String.trim(branch_name),
           branch_name <- System.get_env("GATEWAY_BUILD_BRANCH") || branch_name,
           true <-
             !Enum.any?(["master", "HEAD", "release/", "stable"], fn name ->
               String.starts_with?(name, branch_name)
             end) do
        branch_name =
          branch_name
          |> String.trim()
          |> String.replace(identifier_filter, "-")

        branch_name
      end

    build_name =
      cond do
        name = Application.get_env(:api_gateway, :build_name) -> name
        name = System.get_env("COMMUNITY_BUILD_NAME") -> name
        true -> nil
      end

    env_name = if Mix.env() != :prod, do: to_string(Mix.env())
    env_override = System.get_env("COMMUNITY_BUILD_NAME")

    env_name =
      case env_override do
        nil -> env_name
        env_override when env_override in ["", "prod"] -> nil
        env_override -> env_override
      end

    pre_release =
      [git_pre_release, branch_name]
      |> Enum.filter(fn string -> string && string != "" end)
      |> Enum.join(".")
      |> (fn
        "" -> nil
        string -> "-" <> String.replace(string, identifier_filter, "-")
      end).()

    build_metadata =
      [build_name, env_name]
      |> Enum.filter(fn string -> string && string != "" end)
      |> Enum.join(".")
      |> (fn
        "" -> nil
        string -> "+" <> String.replace(string, identifier_filter, "-")
      end).()

    [version, pre_release, build_metadata]
    |> Enum.filter(fn string -> string && string != "" end)
    |> Enum.join()
  end

  defp bless(_) do
    [
      {"compile", ["--warnings-as-errors", "--force"]},
      {"coveralls.html", []},
      {"format", ["--check-formatted"]},
      {"credo", []}
    ]
    |>  Enum.each(fn {task, args} ->
      IO.ANSI.format([:cyan, "Running #{task} with args #{inspect(args)}"])
      |> IO.puts()

      Mix.Task.run(task, args)
    end)
  end

  defp run_default_coverage(args), do: run_coverage("coveralls", args)
  defp run_html_coverage(args), do: run_coverage("coveralls.html", args)

  defp run_coverage(task, args) do
    {_, res} =
      System.cmd(
        "mix",
        [task | args],
        into: IO.binstream(:stdio, :line),
        env: [{"MIX_ENV", "test"}]
      )

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end

  defp get_commit_sha do
    System.cmd("git", ["rev-parse", "HEAD"])
    |> elem(0)
    |> String.trim()
  end

  defp get_commit_date do
    [sec, tz] =
      System.cmd("git", ~w|log -1 --date=raw --format=%cd|)
      |> elem(0)
      |> String.split(~r/\s+/, trim: true)
      |> Enum.map(&String.to_integer/1)

    DateTime.from_unix!(sec + tz * 36) |> to_string
  end
end
