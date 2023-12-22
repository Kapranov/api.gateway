defmodule Gateway do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use Gateway, :controller
      use Gateway, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  @connector :kafka

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:json]

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: Gateway.Endpoint,
        router: Gateway.Router,
        statics: Gateway.static_paths()
    end
  end

  def handle_messages(messages) do
    for %{key: key, value: value} = message <- messages do
      case is_list(:ets.info(@connector)) do
        true ->
          try do
            :ets.insert(@connector, {key, value})
          rescue
            ArgumentError ->
              IO.inspect message
          end
        false ->
          :ets.new(@connector, [:set, :public, :named_table])
          :ets.insert(@connector, {key, value})
      end
      IO.puts("Received arguments via Gateway: #{inspect(message)}")
    end
    :ok
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
