defmodule Connector.Factory do
  @moduledoc """
  Factory for fixtures with ExMachina.
  """

  use ExMachina.Ecto, repo: Core.Repo

  alias Core.{
    Logs.SmsLog,
    Monitoring.Status,
    Spring.Message
  }

  def status_factory do
    %Status{
      active: true,
      description: "A message was sent to the provider and a positive response was received",
      messages: [],
      sms_logs: [],
      status_code: 103,
      status_name: "send"
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
