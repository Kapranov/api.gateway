defmodule Connector.Timeout do
  @moduledoc """
  API for managing and manipulating configurable timeouts.

  Some following features.

  * API for retrieving and iterating timeouts.
  * Timeout backoff with optional max.
  * Randomizing within a given percent of a desired range.
  * Timer management utilizing the above configuration.
  """

  @name __MODULE__

  @type backoff :: pos_integer | float | nil
  @type backoff_max:: pos_integer | nil
  @type random :: float | nil
  @type timeout_value :: pos_integer
  @type options :: [backoff: backoff, backoff_max: backoff_max, random: random]

  @type t :: %@name{
    backoff: backoff,
    backoff_max: backoff_max,
    backoff_round: non_neg_integer,
    base: timeout_value,
    random: {float, float} | nil,
    timeout: timeout_value,
    timer: reference | nil
  }

  defstruct ~w(base timeout backoff backoff_round backoff_max random timer)a

  @doc """
  Builds a `Timeout` struct.

  Accepts an integer timeout value and the following optional configuration:

  * `:backoff` - A backoff growth factor for growing a timeout period over time.
  * `:backoff_max` - Given `:backoff`, will never grow past max.
  * `:random` - A float indicating the `%` timeout values will be randomized
    within. Expects `0 < :random < 1` or raises an `ArgumentError`. For example,
    use `0.10` to randomize within +/- 10% of the desired timeout.

  ## Example.

      iex> Connector.Timeout.new(100, backoff: 1.25, backoff_max: 1_250, random: 0.10)
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: 1.25,
        backoff_round: 0,
        backoff_max: 1250,
        random: {1.1, 0.9},
        timer: nil
      }

  """
  @spec new(timeout_value, options) :: t
  def new(timeout, opts \\ []) when is_integer(timeout) do
    %@name{
      base: timeout,
      timeout: timeout,
      backoff: Keyword.get(opts, :backoff),
      backoff_round: 0,
      backoff_max: Keyword.get(opts, :backoff_max),
      random: opts |> Keyword.get(:random) |> parse_random_max_min()
    }
  end

  @doc """
  Resets the current timeout.

  ## Example.

      iex> now = Connector.Timeout.new(100, backoff: 1.25, backoff_max: 1_250, random: 0.10)
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: 1.25,
        backoff_round: 0,
        backoff_max: 1250,
        random: {1.1, 0.9},
        timer: nil
      }

      iex> Connector.Timeout.reset(now)
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: 1.25,
        backoff_round: 0,
        backoff_max: 1250,
        random: {1.1, 0.9},
        timer: nil
      }

  """
  @spec reset(t) :: t
  def reset(t = %@name{base: base}) do
    %{t | backoff_round: 0, timeout: base}
  end

  @doc """
  Increments the current timeout based on the `backoff` configuration.

  If there is no `backoff` configured, this function simply returns the timeout
  as is. If `backoff_max` is configured, the timeout will never be incremented
  above that value.

  The first call to `next/1` will always return the initial timeout first.

  ## Example.

      iex> now = Connector.Timeout.new(100)
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: nil,
        backoff_round: 0,
        backoff_max: nil,
        random: nil,
        timer: nil
      }

      iex> now |> Connector.Timeout.next()
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: nil,
        backoff_round: 0,
        backoff_max: nil,
        random: nil,
        timer: nil
      }

      iex> now = Connector.Timeout.new(100, backoff: 1.25)
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: 1.25,
        backoff_round: 0,
        backoff_max: nil,
        random: nil,
        timer: nil
      }

      iex> now |> Connector.Timeout.next()
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: 1.25,
        backoff_round: 1,
        backoff_max: nil,
        random: nil,
        timer: nil
      }

      iex> now |> Connector.Timeout.next() |> Connector.Timeout.next()
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: 1.25,
        backoff_round: 1,
        backoff_max: nil,
        random: nil,
        timer: nil
      }

      iex> now = Connector.Timeout.new(100, backoff: 1.25, backoff_max: 2)
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: 1.25,
        backoff_round: 0,
        backoff_max: 2,
        random: nil,
        timer: nil
      }

      iex> now |> Connector.Timeout.new()
      %Connector.Timeout{
        base: 100,
        timeout: 2,
        backoff: 1.25,
        backoff_round: 1,
        backoff_max: 2,
        random: nil,
        timer: nil
      }

      iex> now |> Connector.Timeout.next() |> Connector.Timeout.next() |> Connector.Timeout.next()
      %Connector.Timeout{
        base: 100,
        timeout: 2,
        backoff: 1.25,
        backoff_round: 1,
        backoff_max: 2,
        random: nil,
        timer: nil
      }

  """
  @spec next(t) :: t
  def next(t = %@name{backoff: nil}), do: t
  def next(t = %@name{base: base, timeout: nil}), do: %{t | timeout: base}
  def next(t = %@name{timeout: c, backoff_max: c}), do: t
  def next(t = %@name{base: c, backoff: b, backoff_round: r, backoff_max: m}) do
    timeout = round(c * :math.pow(b, r))
    %{t | backoff_round: r + 1, timeout: (m && (timeout > m and m)) || timeout}
  end

  @doc """
  Returns the timeout value represented by the current state.

  ## Example.

      iex> Connector.Timeout.new(100) |> Connector.Timeout.current()
      100

  If `backoff` was configured, returns the current timeout with backoff applied:

  ## Example.

      iex> Connector.Timeout.new(100, backoff: 1.25)
        |> Connector.Timeout.next()
        |> Connector.Timeout.next()
        |> Connector.Timeout.current(t)
      125

  If `random` was configured, the current timeout out is randomized within the
  configured range:

  ## Example.

      iex> t = Connector.Timeout.new(100, random: 0.10)
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: nil,
        backoff_round: 0,
        backoff_max: nil,
        random: {1.1, 0.9},
        timer: nil
      }

      iex> if Connector.Timeout.current(t) in 91..110, do: true, else: false
      true

  """
  @spec current(t) :: timeout_value
  def current(%@name{base: base, timeout: nil, random: random}), do: calc_current(base, random)
  def current(%@name{timeout: timeout, random: random}), do: calc_current(timeout, random)

  @doc """
  Sends a process a message with `Process.send_after/3` using the given timeout,
  the stores the resulting timer on the struct.

  Sends the message to `self()` if pid is omitted, otherwise sends to the given
  `pid`.

  Always calls `next/1` first on the given timer, then uses the return value of
  `current/1` to delay the message.

  This function is a convienence wrapper around the following workflow:

  ## Example.

      iex> t = Connector.Timeout.new(100, backoff: 1.25) |> Connector.Timeout.next()
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: 1.25,
        backoff_round: 1,
        backoff_max: nil,
        random: nil,
        timer: nil
      }

      iex> timer = Process.send_after(self(), :message, Connector.Timeout.current(t))
      #Reference<0.4208700307.1029439489.100612>

      iex> t = %{t | timer: timer}
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: 1.25,
        backoff_round: 1,
        backoff_max: nil,
        random: nil,
        timer: #Reference<0.4208700307.1029439489.100612>
      }

      iex> Connector.Timeout.send_after(t, self(), :message)
      {%Connector.Timeout{
          base: 100,
          timeout: 125,
          backoff: 1.25,
          backoff_round: 2,
          backoff_max: nil,
          random: nil,
          timer: #Reference<0.2639114114.226230273.225894>
      }, 125}

  Returns `{%Timeout{}, delay}` where delay is the message schedule delay.

  """
  @spec send_after(t, pid, term) ::{t, pos_integer}
  def send_after(t = %@name{}, pid \\ self(), message) do
    t = next(t)
    delay = current(t)
    {%{t | timer: Process.send_after(pid, message, delay)}, delay}
  end

  @doc """
  Calls `send_after!/3`, but returns only the timeout struct.

  ## Example.

      iex> t = Connector.Timeout.new(100, backoff: 1.25) |> Connector.Timeout.next()
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: 1.25,
        backoff_round: 1,
        backoff_max: nil,
        random: nil,
        timer: nil
      }

      iex> Connector.Timeout.send_after!(t, self(), :message)
      %Connector.Timeout{
        base: 100,
        timeout: 125,
        backoff: 1.25,
        backoff_round: 2,
        backoff_max: nil,
        random: nil,
        timer: #Reference<0.2639114114.226230273.225162>
      }

  """
  @spec send_after!(t, pid, term) :: t
  def send_after!(t = %@name{}, pid \\ self(), message) do
    with {timeout, _delay} <- send_after(t, pid, message), do: timeout
  end

  @doc """
  Cancels the stored timer.

  Returns `{%Timeout{}, result}` where result is the value returned by calling
  `Process.cancel_timer/1` on the stored timer reference.

  ## Example.

      iex> t = Connector.Timeout.new(100, backoff: 1.25) |> Connector.Timeout.next()
      %Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: 1.25,
        backoff_round: 1,
        backoff_max: nil,
        random: nil,
        timer: nil
      }

      iex> Connector.Timeout.cancel_timer(t)
      {%Connector.Timeout{
        base: 100,
        timeout: 100,
        backoff: 1.25,
        backoff_round: 1,
        backoff_max: nil,
        random: nil,
        timer: nil
      }, false}

      iex> t = Connector.Timeout.new(100, backoff: 1.25) |> Connector.Timeout.next() |> Connector.Timeout.send_after!(:msg)
      %Connector.Timeout{
        base: 100,
        timeout: 125,
        backoff: 1.25,
        backoff_round: 2,
        backoff_max: nil,
        random: nil,
        timer: #Reference<0.2297875499.1573126146.97470>
      }

      iex> Connector.Timeout.cancel_timer(t)
      {%Connector.Timeout{
        base: 100,
        timeout: 125,
        backoff: 1.25,
        backoff_round: 2,
        backoff_max: nil,
        random: nil,
        timer: nil
      }, false}
  """
  @spec cancel_timer(t) :: {t, non_neg_integer | false | :ok}
  def cancel_timer(t = %@name{timer: nil}), do: {t, false}
  def cancel_timer(t = %@name{timer: timer}) when is_reference(timer) do
    {%{t | timer: nil}, Process.cancel_timer(timer)}
  end

  @doc """
  Calls `cancel_timer/1` but returns only the timeout struct.

  ## Example.

      iex> t = Connector.Timeout.new(100, backoff: 1.25) |> Connector.Timeout.next() |> Connector.Timeout.send_after!(:msg)
      %Connector.Timeout{
        base: 100,
        timeout: 125,
        backoff: 1.25,
        backoff_round: 2,
        backoff_max: nil,
        random: nil,
        timer: #Reference<0.2297875499.1573126146.99983>
      }

      iex> Connector.Timeout.cancel_timer!(t)
      %Connector.Timeout{
        base: 100,
        timeout: 125,
        backoff: 1.25,
        backoff_round: 2,
        backoff_max: nil,
        random: nil,
        timer: nil
      }

  Returns `{%Timeout{}, result}` where result is the value returned by calling
  `Process.cancel_timer/1` on the stored timer reference.
  """
  @spec cancel_timer!(t) :: t
  def cancel_timer!(t = %@name{}) do
    with {timeout, _result} <- cancel_timer(t), do: timeout
  end

  defp parse_random_max_min(nil), do: nil
  defp parse_random_max_min(range) when is_float(range) and range > 0 and range < 1 do
    {1.0 + range, 1.0 - range}
  end
  defp parse_random_max_min(range) do
    raise ArgumentError, "Invalid option for :random. Expected 0 < float < 1, got: #{range}"
  end

  defp calc_current(timeout, nil), do: timeout
  defp calc_current(timeout, {rmax, rmin}) do
    max = round(timeout * rmax)
    min = round(timeout * rmin)
    min + do_rand(max - min)
  end

  defp do_rand(0), do: 0
  defp do_rand(n), do: :rand.uniform(n)
end
