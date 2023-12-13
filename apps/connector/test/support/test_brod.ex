defmodule TestBrod do
  use GenServer

  @name __MODULE__
  @report_threshold 40
  @test_partition_count Application.compile_env(:kaffe, :test_partition_count)

  require Logger

  def start_link([]) do
    GenServer.start_link(@name, :ok, name: TestBrod)
  end

  def runner(args), do: send_message(1, args)

  def produce_sync(key, value) do
    GenServer.call(TestBrod, {:produce_sync, key, value})
  end

  def get_partitions_count(_client, _topic), do: {:ok, @test_partition_count}

  def set_produce_response(response) do
    GenServer.call(TestBrod, {:set_produce_response, response})
  end

  def init(:ok) do
    {:ok, %{produce_response: :ok}}
  end

  def handle_call({:produce_sync, key, value}, _from, state) do
    send(:test_case, [:produce_sync, key, value])
    {:reply, state.produce_response, state}
  end

  def handle_call({:set_produce_response, response}, _from, state) do
    {:reply, response, %{state | produce_response: response}}
  end

  defp send_message(n, args) do
    t_start = :os.system_time(:milli_seconds)

    if n > 0 do
      try do
        TestBrod.produce_sync("#{args.id}", "#{args.phone_number}, #{args.message_body}")
      rescue
        e -> e
      catch
        e -> e
      after
        t_end = :os.system_time(:milli_seconds)
        t_diff = t_end - t_start
        n = 1
        if t_diff > @report_threshold do
          Logger.log(:info, "Message #{n} Took: #{t_diff}")
        end
        send_message(n - 1, args)
      end
    end
  end
end
