defmodule KafkaImpl.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      %{
        id: KafkaImpl.KafkaMock,
        start: {KafkaImpl.KafkaMock, :start_link, []}
      }
    ]
    opts = [strategy: :one_for_one, name: KafkaImpl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
