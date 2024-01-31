defmodule Connector.Retry do
  @moduledoc """
  See `#{__MODULE__}.autoretry/2`
  """

  @max_attempts 5
  @attempt 15_000
  @get_attempt Application.compile_env(:connector, :attempt)
  @get_include_404s Application.compile_env(:connector, :include_404s)
  @get_max_attempts Application.compile_env(:connector, :max_attempts)
  @get_retry_unknown_errors Application.compile_env(:connector, :retry_unknown_errors)
  @get_wait Application.compile_env(:connector, :wait)

  @doc """
  """
  defmacro autoretry(attempt, opts \\ []) do
    quote location: :keep, generated: true do
      attempt_fn = fn -> unquote(attempt) end
      opts = Keyword.merge([
        max_attempts: unquote(@get_max_attempts) || unquote(@max_attempts),
        wait: unquote(@get_wait) || unquote(@attempt),
        include_404s: unquote(@get_include_404s) || false,
        retry_unknown_errors: unquote(@get_retry_unknown_errors) || false,
        attempt: unquote(@get_attempt) || 1
      ],
      unquote(opts)
      )

      case attempt_fn.() do
        {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}} ->
          Connector.Retry.next_attempt(attempt_fn, opts)
        {:error, %HTTPoison.Error{id: nil, reason: :timeout}} ->
          Connector.Retry.next_attempt(attempt_fn, opts)
        {:error, %HTTPoison.Error{id: nil, reason: :closed}} ->
          Connector.Retry.next_attempt(attempt_fn, opts)
        {:error, %HTTPoison.Error{id: nil, reason: _}} = response ->
          if Keyword.get(opts, :retry_unknown_errors) do
            Connector.Retry.next_attempt(attempt_fn, opts)
          else
            response
          end
        {:ok, %HTTPoison.Response{status_code: 500}} ->
          Connector.Retry.next_attempt(attempt_fn, opts)
        {:ok, %HTTPoison.Response{status_code: 404}} = response ->
          if Keyword.get(opts, :include_404s) do
            Connector.Retry.next_attempt(attempt_fn, opts)
          else
            response
          end
        response ->
          response
      end
    end
  end

  def next_attempt(attempt, opts) do
    Process.sleep(opts[:wait])
    if opts[:max_attempts] == :infinity || opts[:attempt] < opts[:max_attempts] - 1 do
      opts = Keyword.put(opts, :attempt, opts[:attempt] + 1)
      autoretry(attempt.(), opts)
    else
      attempt.()
    end
  end
end
