defmodule Core.Config do
  @moduledoc """
  Configuration wrapper.
  """

  @spec get(module() | atom()) :: any()
  def get(key), do: get(key, nil)

  @spec get([module() | atom()]) :: any()
  def get([key], default), do: get(key, default)

  @spec get([module() | atom()], Stting.t()) :: any()
  def get([parent_key | keys], default) do
    case get_in(Application.get_env(:core, parent_key), keys) do
      nil -> default
      any -> any
    end
  end

  @spec get(module() | atom(), any()) :: any()
  def get(key, default), do: Application.get_env(:core, key, default)

  @spec get!(module() | atom()) :: any()
  def get!(key) do
    value = get(key, nil)

    if value == nil do
      raise("Missing configuration value: #{inspect(key)}")
    else
      value
    end
  end

  @spec put([module() | atom()], any()) :: any()
  def put([key], value), do: put(key, value)

  @spec put([module() | atom()], any()) :: any()
  def put([parent_key | keys], value) do
    parent =
      Application.get_env(:core, parent_key, [])
      |> put_in(keys, value)

    Application.put_env(:core, parent_key, parent)
  end

  @spec put(module() | atom(), any()) :: any()
  def put(key, value), do:
    Application.put_env(:core, key, value)

  @spec delete([module() | atom()]) :: any()
  def delete([key]), do: delete(key)

  @spec delete([module() | atom()]) :: any()
  def delete([parent_key | keys]) do
    {_, parent} =
      Application.get_env(:core, parent_key)
      |> get_and_update_in(keys, fn _ -> :pop end)

    Application.put_env(:core, parent_key, parent)
  end

  @spec delete(module() | atom()) :: any()
  def delete(key) do
    Application.delete_env(:core, key)
  end
end
