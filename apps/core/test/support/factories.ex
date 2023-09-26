defmodule Core.Factory do
  @moduledoc """
  Factory for fixtures with ExMachina.
  """

  use ExMachina.Ecto, repo: Core.Repo

  alias Core.{
    Monitoring.Status,
    Operators.Config,
    Operators.Operator,
    Operators.OperatorType,
    Operators.Parameters,
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
      messages: [],
      sms_logs: [],
      status_code: 1,
      status_name: "status #1"
    }
  end

  def operator_type_factory do
    %OperatorType{
      active: true,
      name_type: "some text",
      operator: nil,
      priority: 1
    }
  end

  def operator_factory do
    %Operator{
      active: true,
      config: build(:config),
      limit_count: 1,
      name_operator: "some text",
      operator_type: build(:operator_type),
      phone_code: "+380991111111",
      price_ext: 1,
      price_int: 1,
      priority: 1,
      sms_logs: []
    }
  end

  def config_factory do
    %Config{
      id: FlakeId.get(),
      content_type: "some text",
      name: "some text",
      size: 1,
      url: "some text",
      inserted_at: DateTime.utc_now(:millisecond, Calendar.ISO),
      updated_at: DateTime.utc_now(:millisecond, Calendar.ISO)
    }
  end

  def parameters_factory do
    %Parameters{
      id: FlakeId.get(),
      key: "some text",
      value: "some text",
      inserted_at: DateTime.utc_now(:millisecond, Calendar.ISO),
      updated_at: DateTime.utc_now(:millisecond, Calendar.ISO)
    }
  end
end
