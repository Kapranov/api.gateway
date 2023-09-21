defmodule Core.Factory do
  @moduledoc """
  Factory for fixtures with ExMachina.
  """

  use ExMachina.Ecto, repo: Core.Repo

  alias Core.{
    Settings.Setting
  }

  alias Faker.Lorem

  def setting_factory do
    %Setting{
      param: Lorem.sentence(),
      value: Lorem.sentence()
    }
  end
end
