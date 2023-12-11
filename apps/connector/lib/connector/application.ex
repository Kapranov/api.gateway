defmodule Connector.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      %{
        id: Kaffe.GroupMemberSupervisor,
        start: {Kaffe.GroupMemberSupervisor, :start_link, []},
        type: :supervisor
      }
      #{Connector.Monitor, []}
      #{VodafoneHandler, [{FlakeId.get()}]}
      #{VodafoneHandler, [{"Ab7ug1QFqdre94zgRM"}]}
    ]
    opts = [strategy: :one_for_one, name: Connector.Application.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
