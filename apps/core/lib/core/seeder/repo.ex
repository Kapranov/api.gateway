defmodule Core.Seeder.Repo do
  @moduledoc """
  Seeds for `Core.Seeder.Repo` repository.
  """

  alias Core.Seeder.{
    Deleted,
    Logs,
    Monitoring,
    Operators,
    Settings,
    Spring,
    Updated
  }

  @spec seed!() :: :ok
  def seed! do
    Settings.seed!()
    :timer.sleep(3_000)
    Operators.seed!()
    :timer.sleep(3_000)
    Monitoring.seed!()
    :timer.sleep(3_000)
    Spring.seed!()
    :timer.sleep(3_000)
    Logs.seed!()
    :ok
  end

  @spec updated!() :: :ok
  def updated! do
    Updated.Settings.start!()
    :timer.sleep(3_000)
    Updated.Operators.start!()
    :timer.sleep(3_000)
    Updated.Logs.start!()
    :ok
  end

  @spec deleted!() :: :ok
  def deleted! do
    Deleted.Settings.start!()
    :timer.sleep(3_000)
    Deleted.Operators.start!()
    :timer.sleep(3_000)
    Deleted.Monitoring.start!()
    :timer.sleep(3_000)
    Deleted.Spring.start!()
    :timer.sleep(3_000)
    Deleted.Logs.start!()
    :ok
  end
end
