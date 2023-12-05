defmodule Connector.Application do
  @moduledoc false

  use Application

  # alias Connector.VodafoneHandler

  @impl true
  def start(_type, _args) do
    children = [
      %{
        id: Kaffe.Consumer,
        start: {Kaffe.Consumer, :start_link, []}
      }
      #{VodafoneHandler, [{FlakeId.get()}]}
      #{VodafoneHandler, [{"Ab7ug1QFqdre94zgRM"}]}
    ]
    opts = [strategy: :one_for_one, name: Connector.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
