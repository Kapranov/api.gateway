defmodule Core.Factory do
  @moduledoc """
  Factory for fixtures with ExMachina.
  """

  use ExMachina.Ecto, repo: Core.Repo

  alias Core.{
    Monitoring.Status,
    Settings.Setting
  }

  alias Faker.Lorem

  def setting_factory do
    %Setting{
      param: Lorem.sentence(),
      value: Lorem.sentence()
    }
  end

  def status_factory do
    %Status{
      active: true,
      description: "some text",
      status_code: 1,
      status_name: "status #1"
    }
  end
end
