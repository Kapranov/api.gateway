defmodule Gateway.Application do
  @moduledoc false

  use Application

  require Logger

  @connector :kafka

  @doc """
  Starts the endpoint supervision tree.
  """
  @spec start(Application.start_type(), start_args :: term()) ::
          {:ok, pid()} | {:ok, pid(), Application.state()} | {:error, reason :: term()}
  def start(_type, _args) do
    load_version()
    children = [
      Gateway.Telemetry,
      Gateway.Endpoint,
      {Phoenix.PubSub, [name: Gateway.PubSub, adapter: Phoenix.PubSub.PG2]},
      {Absinthe.Subscription, Gateway.Endpoint}
    ]
    opts = [strategy: :one_for_one, name: Gateway.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Callback that changes the configuration from the app callback.
  """
  @spec config_change(list(tuple()), list(tuple()), list(any())) :: :ok
  def config_change(changed, _new, removed) do
    Gateway.Endpoint.config_change(changed, removed)
    :ok
  end

  @spec load_version() :: map()
  def load_version do
    [vsn, hash, date] =
      case File.read("VERSION") do
        {:ok, data} -> data |> String.split("\n")
        _ -> [nil, nil, nil]
      end

    version = %{vsn: vsn, hash: hash, date: date}
    Logger.info("Loading app version: #{inspect(version)}")
    Application.put_env(:gateway, :version, version)
  end

  @spec handle_messages(%{key: any(), value: any()}) :: :ok
  def handle_messages(messages) do
    for %{key: key, value: value} = message <- messages do
      case is_list(:ets.info(@connector)) do
        true ->
          try do
            :ets.insert(@connector, {key, value})
          rescue
            ArgumentError ->
              IO.inspect message
          end
        false ->
          :ets.new(@connector, [:set, :public, :named_table])
          :ets.insert(@connector, {key, value})
      end
      IO.inspect message
    end
    :ok
  end
end
