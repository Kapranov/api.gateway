defmodule Core.Seeder.Repo do
  @moduledoc """
  Seeds for `Core.Seeder.Repo` repository.
  """

  alias Core.Seeder.{
    Deleted,
    Operators,
    Updated
  }

  @spec seed!() :: :ok
  def seed! do
    Operators.seed!()
    :ok
  end

  @spec updated!() :: :ok
  def updated! do
    Updated.Operators.start!()
    :ok
  end

  @spec deleted!() :: :ok
  def deleted! do
    Deleted.Operators.start!()
    :ok
  end
end
