defmodule Core.Context do
  @moduledoc """
  Extention Ecto.* for context
  """

  defmacro __using__(_) do
    quote do
      alias Core.Repo
      alias Ecto.{Changeset, Multi}
      import Ecto.Query

      @type t :: __MODULE__.t()
      @type reason :: any
      @type success_tuple :: {:ok, t}
      @type error_tuple :: {:error, reason}
      @type result :: success_tuple | error_tuple
    end
  end
end
