defmodule Core.Factory do
  @moduledoc """
  Factory for fixtures with ExMachina.
  """

  use ExMachina.Ecto, repo: Core.Repo

  alias Core.{
    Logs.SmsLog,
    Monitoring.Status,
    Operators.Config,
    Operators.Operator,
    Operators.OperatorType,
    Operators.Parameters,
    Settings.Setting,
    Spring.Message
  }

  def setting_factory do
    %Setting{
      param: "some text",
      value: "some text"
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
      phone_code: "063, 093, 096",
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

  def message_factory do
    %Message{
      id_external: "1",
      id_tax: 1_111_111_111,
      id_telegram: "length text",
      message_body: "some text",
      message_expired_at: random_datetime(+7),
      phone_number: "+380991111111",
      sms_logs: [build(:sms_log)],
      status: build(:status),
      status_changed_at: random_datetime(+3)
    }
  end

  def sms_log_factory do
    %SmsLog{priority: 1}
  end

  @spec random_datetime(neg_integer() | pos_integer()) :: DateTime.t()
  defp random_datetime(num) do
    timestamp =
      DateTime.utc_now
      |> DateTime.add(num, :day)

    timestamp
  end
end
