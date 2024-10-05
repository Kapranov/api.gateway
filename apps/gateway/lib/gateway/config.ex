defmodule Gateway.Endpoint.Config do
  @moduledoc false

  def child_spec(opts) do
    %{
      id: Gateway.Endpoint,
      start: {Gateway.Endpoint.Config, :start_link, [opts]},
      type: :supervisor
    }
  end

  def start_link(opts) do
    dynamic_config(opts)
    |> Gateway.Endpoint.start_link()
  end

  defp dynamic_config(_opts) do
    [url: [scheme: "http", host: "localhost", port: 4000]]
  end
end
