defmodule Core.Seeder.Repo do
  @moduledoc """
  Seeds for `Core.Seeder.Repo` repository.
  """

  alias Core.Seeder.{
    Deleted,
    Operators,
    Settings,
    Updated
  }

  @spec seed!() :: :ok
  def seed! do
    Operators.seed!()
    Settings.seed!()
    :ok
  end

  @spec updated!() :: :ok
  def updated! do
    Updated.Operators.start!()
    Updated.Settings.start!()
    :ok
  end

  @spec deleted!() :: :ok
  def deleted! do
    Deleted.Operators.start!()
    Deleted.Settings.start!()
    :ok
  end
end
