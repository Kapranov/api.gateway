defmodule Connector.RetryTest do
  use ExUnit.Case
  import Connector.Retry

  @count 10

  test "when max_attempts is 0 and response is 2" do
    {:ok, agent} = Agent.start fn -> 0 end

    assert is_pid(agent) == true
    assert :sys.get_state(agent) == 0

    request = fn ->
      Agent.update agent, fn(i) -> i + 1 end
      {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}
    end

    assert {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}} = autoretry(request.(), [max_attempts: 0])
    assert 2 = Agent.get(agent, &(&1))
    assert :sys.get_state(agent) == 2
  end

  test "when max_attempts is 1 and response is 2" do
    {:ok, agent} = Agent.start fn -> 0 end

    assert is_pid(agent) == true
    assert :sys.get_state(agent) == 0

    request = fn ->
      Agent.update agent, fn(i) -> i + 1 end
      {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}
    end

    assert {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}} = autoretry(request.(), [max_attempts: 1])
    assert 2 = Agent.get(agent, &(&1))
    assert :sys.get_state(agent) == 2
  end

  test "when max_attempts is 2 and response is 2" do
    {:ok, agent} = Agent.start fn -> 0 end

    assert is_pid(agent) == true
    assert :sys.get_state(agent) == 0

    request = fn ->
      Agent.update agent, fn(i) -> i + 1 end
      {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}
    end

    assert {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}} = autoretry(request.(), [max_attempts: 2])
    assert 2 = Agent.get(agent, &(&1))
    assert :sys.get_state(agent) == 2
  end

  test "when max_attempts is 10 and response is 10" do
    {:ok, agent} = Agent.start fn -> 0 end

    assert is_pid(agent) == true
    assert :sys.get_state(agent) == 0

    request = fn ->
      Agent.update agent, fn(i) -> i + 1 end
      {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}
    end

    assert {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}} = autoretry(request.(), [max_attempts: 10])
    assert 10 = Agent.get(agent, &(&1))
    assert :sys.get_state(agent) == 10
  end

  test "when max_attempts is 99 and response is 99" do
    {:ok, agent} = Agent.start fn -> 0 end

    assert is_pid(agent) == true
    assert :sys.get_state(agent) == 0

    request = fn ->
      Agent.update agent, fn(i) -> i + 1 end
      {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}
    end

    assert {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}} = autoretry(request.(), [max_attempts: 99])
    assert 99 = Agent.get(agent, &(&1))
    assert :sys.get_state(agent) == 99
  end

  test "nxdomain errors" do
    {:ok, agent} = Agent.start fn -> 0 end
    request = fn ->
      Agent.update agent, fn(i) -> i + 1 end
      {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}
    end

    assert {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}} = autoretry(request.())
    assert 5 = Agent.get(agent, &(&1))
  end

  test "500 errors" do
    {:ok, agent} = Agent.start fn -> 0 end
    request = fn ->
      Agent.update agent, fn(i) -> i + 1 end
      {:ok, %HTTPoison.Response{status_code: 500}}
    end

    assert {:ok, %HTTPoison.Response{status_code: 500}} = autoretry(request.())
    assert 5 = Agent.get(agent, &(&1))
  end

  test "errors other than nxdomain/timeout by default" do
    {:ok, agent} = Agent.start fn -> 0 end
    request = fn ->
      Agent.update agent, fn(i) -> i + 1 end
      {:error, %HTTPoison.Error{id: nil, reason: :other}}
    end

    assert {:error, %HTTPoison.Error{id: nil, reason: :other}} = autoretry(request.())
    assert 1 = Agent.get(agent, &(&1))
  end

  test "include other error types" do
    {:ok, agent} = Agent.start fn -> 0 end
    request = fn ->
      Agent.update agent, fn(i) -> i + 1 end
      {:error, %HTTPoison.Error{id: nil, reason: :other}}
    end

    assert {:error, %HTTPoison.Error{id: nil, reason: :other}} = autoretry(request.(), retry_unknown_errors: true)
    assert 5 = Agent.get(agent, &(&1))
  end

  test "404s by default" do
    {:ok, agent} = Agent.start fn -> 0 end
    request = fn ->
      Agent.update agent, fn(i) -> i + 1 end
      {:ok, %HTTPoison.Response{status_code: 404}}
    end

    assert {:ok, %HTTPoison.Response{status_code: 404}} = autoretry(request.())
    assert 1 = Agent.get(agent, &(&1))
  end

  test "include 404s" do
    {:ok, agent} = Agent.start fn -> 0 end
    request = fn ->
      Agent.update agent, fn(i) -> i + 1 end
        {:ok, %HTTPoison.Response{status_code: 404}}
    end

    assert {:ok, %HTTPoison.Response{status_code: 404}} = autoretry(request.(), [include_404s: true])
    assert 5 = Agent.get(agent, &(&1))
  end

  test "successful" do
    {:ok, agent} = Agent.start fn -> 0 end
    request = fn ->
      Agent.update agent, fn(i) -> i + @count end
      {:ok, %HTTPoison.Response{status_code: 200}}
    end

    assert {:ok, %HTTPoison.Response{status_code: 200}} = autoretry(request.())
    assert @count = Agent.get(agent, &(&1))
    assert :sys.get_state(agent) == @count
  end

  test "1 failure followed by 1 successful" do
    {:ok, agent} = Agent.start fn -> 0 end
    request = fn ->
      if Agent.get_and_update(agent, fn(i) -> {i + 1, i + 1} end) > 1 do
        {:ok, %HTTPoison.Response{status_code: 200}}
      else
        {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}
      end
    end

    assert {:ok, %HTTPoison.Response{status_code: 200}} = autoretry(request.())
    assert 2 = Agent.get(agent, &(&1))
  end

  test "4 failures followed by 1 successful" do
    {:ok, agent} = Agent.start fn -> 0 end
    request = fn ->
      if Agent.get_and_update(agent, fn(i) -> {i + 1, i + 1} end) > 4 do
        {:ok, %HTTPoison.Response{status_code: 200}}
      else
        {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}
      end
    end

    assert {:ok, %HTTPoison.Response{status_code: 200}} = autoretry(request.())
    assert 5 = Agent.get(agent, &(&1))
  end
end
