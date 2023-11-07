defmodule Connector.DiaHandler do
  @moduledoc """
  Dia external api calls.
  """

  use GenServer

  alias Core.{
    Repo,
    Spring.Message
  }

  @name __MODULE__

  def start_link(args), do: GenServer.start_link(@name, args, name: @name)

  # `code_change/3`
  # `format_status/1`
  # `handle_call/2`
  # `handle_cast/2`
  # `handle_continue/2`
  # `handle_info/2`
  # `init/1`
  # `terminate/2`

  def init([{message_id}]) do
    case check_id(message_id) do
      nil ->
        {:ok, message_id, {:continue, :found}}
      struct ->
        {:ok, %{
            id: struct.id,
            message_body: struct.message_body,
            phone_number: struct.phone_number
          }}
    end
  end

  def handle_continue(:found, state), do: {:noreply, state}
  def handle_continue(nil, state), do: {:stop, :normal, state}

  #def handle_call(request, _from, state), do: {:noreply, request, state}
  #def handle_cast(_request, state), do: {:noreply, state}
  #def handle_info(_term, state), do: {:noreply, state}

  def handle_info(:work, state) do
    schedule_work()
    {:noreply, state}
  end

  def terminate(_reason, _state), do: :ok

  @spec check_id(String.t()) :: Message.t() | nil
  def check_id(id), do: Repo.get(Message, id)

  @spec schedule_work() :: Reference.t()
  def schedule_work do
    Process.send_after(self(), :work, 2 * 60 * 60 * 1000)
  end

  @spec schedule() :: Reference.t()
  def schedule, do: :timer.hours(2)
end
