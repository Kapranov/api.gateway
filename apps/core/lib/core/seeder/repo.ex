defmodule Core.Seeder.Repo do
  @moduledoc """
  Seeds for `Core.Seeder.Repo` repository.
  """

  alias Core.Seeder.{
    #Deleted,
    Logs,
    Monitoring,
    Operators,
    Settings,
    Spring,
    Updated
  }

  @spec seed!() :: :ok
  def seed! do
    Operators.seed!()
    Settings.seed!()
    Monitoring.seed!()
    Spring.seed!()
    Logs.seed!()
    :ok
  end

  @spec updated!() :: :ok
  def updated! do
    Updated.Operators.start!()
    Updated.Settings.start!()
    Updated.Logs.start!()
    :ok
  end

  @spec deleted!() :: :ok
  def deleted! do
    #Deleted.Operators.start!()
    #Deleted.Settings.start!()
    #Deleted.Monitoring.start!()
    #Deleted.Spring.start!()
    #Deleted.Logs.start!()
    :ok
  end
end
