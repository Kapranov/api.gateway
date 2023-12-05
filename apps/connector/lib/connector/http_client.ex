defmodule Connector.HTTPClient do
  @moduledoc """
  Http web client for api calls.
  """

  use GenServer

  alias Core.{
    Monitoring.Status,
    Repo,
    Spring.Message
  }

  alias Connector.HTTPServer

  @name __MODULE__
  @timeout 1_000

  @doc """
  Client HTTP Request & Response Service.

  ## Example.

      iex> struct = Core.Repo.all(Core.Spring.Message) |> List.last |> Map.from_struct
      iex> args = Map.merge(struct, %{connector: "vodafone"})
      iex> {:ok, pid} = Connector.HTTPClient.start_link(args)
      {:ok, pid}
      Received arguments: %{id: "Ac7y2LxiD9lsV2Oeiu", connector: "vodafone", message_body: "Ваш код - 7777-999-9999-9999 - vodafone", phone_number: "+380991111111"}
      Received arguments: %{id: "Ac7y2LxiD9lsV2Oeiu", status: "send", text: "Ваш код - 7777-999-9999-9999 - vodafone", connector: "vodafone", sms: "+380991111111"}
      Received arguments: %{id: "Ac7y2LxiD9lsV2Oeiu", status: "delivered", text: "Ваш код - 7777-999-9999-9999 - vodafone", connector: "vodafone", sms: "+380991111111"}
      iex> Connector.HTTPClient.get_state(pid)
      %{
        connector: "vodafone",
        id: "Ac7y2LxiD9lsV2Oeiu",
        sms: "+380991111111",
        status: "delivered",
        text: "Ваш код - 7777-999-9999-9999 - vodafone"
      }
      iex> {:ok, pid} = Connector.HTTPClient.stop(pid)

      iex> {:ok, pid} = Connector.HTTPClient.start_link(args)
      {:ok, pid}
      Received arguments: %{id: "Ac7y2LxiD9lsV2Oeiu", connector: "vodafone", message_body: "Ваш код - 7777-999-9999-9999 - vodafone", phone_number: "+380991111111"}
      Received arguments: %{id: "Ac7y2LxiD9lsV2Oeiu", status: "send", text: "Ваш код - 7777-999-9999-9999 - vodafone", connector: "vodafone", sms: "+380991111111"}
      Received arguments: %{id: "Ac7y2LxiD9lsV2Oeiu", status: "delivered", text: "Ваш код - 7777-999-9999-9999 - vodafone", connector: "vodafone", sms: "+380991111111"}
      iex> Connector.HTTPClient.get_state(pid)
      :error
      iex> {:ok, pid} = Connector.HTTPClient.stop(pid)

      iex> {:ok, pid} = Connector.HTTPClient.start_link(args)
      {:ok, pid}
      Received arguments: %{id: "Ac7y2LxiD9lsV2Oeiu", connector: "vodafone", message_body: "Ваш код - 7777-999-9999-9999 - vodafone", phone_number: "+380991111111"}
      Received arguments: %{id: "Ac7y2LxiD9lsV2Oeiu", status: "send", text: "Ваш код - 7777-999-9999-9999 - vodafone", connector: "vodafone", sms: "+380991111111"}
      Received arguments: %{id: "Ac7y2LxiD9lsV2Oeiu", status: "delivered", text: "Ваш код - 7777-999-9999-9999 - vodafone", connector: "vodafone", sms: "+380991111111"}
      iex> Connector.HTTPClient.get_state(pid)
      :timeout
      iex> {:ok, pid} = Connector.HTTPClient.stop(pid)

  """
  @spec start_link(map()) :: {atom(), pid} | atom()
  def start_link(args) do
      GenServer.start_link(@name, args, name: @name)
    catch
      :exit, _reason -> :error
  end

  @doc """
  Get information by process.

  ## Example.

      iex> struct = Core.Repo.all(Core.Spring.Message) |> List.last |> Map.from_struct
      iex> args = Map.merge(struct, %{connector: "vodafone"})
      iex> {:ok, pid} = Connector.HTTPClient.start_link(args)
      {:ok, pid}
      iex> Connector.HTTPClient.get_state(pid)
      :timeout
      iex> {:ok, pid} = Connector.HTTPClient.stop(pid)
      :ok

  """
  @spec get_state(pid()) :: map() | atom()
  def get_state(pid) when is_pid(pid) do
      :sys.get_state(pid)
    catch
      :exit, _reason -> :timeout
  end

  @spec stop(pid) :: atom()
  def stop(pid) do
      GenServer.stop(pid, :normal, @timeout)
    catch
      :exit, _reason -> :error
  end

  @spec init(map()) ::
        {atom(), map(), {:continue, atom()}} |
        {atom(), atom(), {:continue, atom()}}
  def init(args) do
    {:ok, args, {:continue, :fetch_from_db}}
  end

  @spec handle_continue(atom(), map()) ::
        {:noreply, atom(), {:continue, atom()}} |
        {:noreply, map(), {:continue, atom()}}
  def handle_continue(:fetch_from_db, state) do
    case check_id(state.id) do
      nil ->
        {:noreply, :error, {:continue, :none_record}}
      struct ->
        data = %{
          connector: state.connector,
          id: struct.id,
          message_body: struct.message_body,
          phone_number: struct.phone_number
        }
        {:noreply, data, {:continue, :connected}}
    end
  end

  @spec handle_continue(atom(), atom()) ::
        {:noreply, atom()}
  def handle_continue(:none_record, state) do
    {:noreply, state}
  end

  @spec handle_continue(atom(), map()) ::
        {:noreply, map()} |
        {:noreply, atom(), {:continue, atom()}}
  def handle_continue(:connected, state) do
    case Connector.HTTPServer.start_link(state) do
      {:ok, pid} ->
        IO.puts("Received arguments: #{inspect(state)}")
        error = Repo.get_by(Status, %{status_name: "error"})
        expired = Repo.get_by(Status, %{status_name: "expired"})
        queue = Repo.get_by(Status, %{status_name: "queue"})
        data = HTTPServer.get_status(state.id, 3, queue.id, expired.id, error.id)
        case data do
          :error ->
            HTTPServer.stop(pid)
            {:noreply, :error, {:continue, :none_record}}
          :timeout ->
            HTTPServer.stop(pid)
            {:noreply, :timeout, {:continue, :none_record}}
          data ->
            HTTPServer.stop(pid)
            {:noreply, data}
        end
      _ ->
        {:noreply, state}
    end
  end

  @spec handle_continue(any(), map() | atom()) ::
        {:noreply, map()} |
        {:noreply, atom()}
  def handle_continue(_args, state) do
    {:noreply, state}
  end

  @spec handle_info(atom(), map()) ::
        {:noreply, map()} |
        {:noreply, atom()}
  def handle_info(:none_record, state) do
    IO.puts("Received arguments: #{inspect(state)}")
    {:noreply, state}
  end

  @spec handle_info(atom(), map()) ::
        {:noreply, map()} |
        {:noreply, atom()}
  def handle_info(:found, state) do
    IO.puts("Received arguments: #{inspect(state)}")
    {:noreply, state}
  end

  @spec handle_info(any(), map()) ::
        {:noreply, map()} |
        {:noreply, atom()}
  def handle_info(_msg, state) do
    IO.puts("Received arguments: #{inspect(state)}")
    {:noreply, state}
  end

  @spec terminate(any(), any()) :: atom()
  def terminate(_reason, _state), do: :ok

  @spec check_id(String.t()) :: Message.t() | nil
  defp check_id(id), do: Repo.get(Message, id)
end
