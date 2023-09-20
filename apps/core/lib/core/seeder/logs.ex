defmodule Core.Seeder.Logs do
  @moduledoc """
  Seeds for `Core.Logs` context.
  """

  alias Core.{
    Logs,
    Logs.SmsLog,
    Monitoring.Status,
    Operators.Operator,
    Repo,
    Spring.Message
  }

  alias Ecto.Adapters.SQL

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    SQL.query!(Repo, "TRUNCATE sms_logs CASCADE;")
    IO.puts("Deleting old data in Model's SmsLogs\n")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_sms_log()
    IO.puts("Inserted data on model's Logs\n")
  end

  @spec seed_sms_log() :: nil | Ecto.Schema.t()
  defp seed_sms_log do
    case Repo.aggregate(SmsLog, :count, :id) > 0 do
      true -> nil
      false -> insert_sms_log()
    end
  end

  @spec insert_sms_log() :: {:ok, any()} | {:error, any()}
  defp insert_sms_log do
    msg_ids = Enum.map(Repo.all(Message), &(&1))
    operator_ids = Enum.map(Repo.all(Operator), &(&1))
    status_ids = Enum.map(Repo.all(Status), &(&1))

    {
      msg2,
      msg4,
      msg5,
      msg6
    } = {
      Enum.at(msg_ids, 1),
      Enum.at(msg_ids, 3),
      Enum.at(msg_ids, 4),
      Enum.at(msg_ids, 5)
    }

    {
      operator1,
      operator2,
      operator5
    } = {
      Enum.at(operator_ids, 0),
      Enum.at(operator_ids, 1),
      Enum.at(operator_ids, 4)
    }

    {
      status1,
      status2,
      status3
    } = {
      Enum.at(status_ids, 0),
      Enum.at(status_ids, 1),
      Enum.at(status_ids, 2)
    }

    [
      Logs.create_sms_log(%{
        messages: msg4.id,
        operators: operator1.id,
        statuses: status1.id,
        priority: 1
      }),
      Logs.create_sms_log(%{
        messages: msg4.id,
        operators: operator2.id,
        statuses: status2.id,
        priority: 2
      }),
      Logs.create_sms_log(%{
        messages: msg4.id,
        operators: operator5.id,
        statuses: status3.id,
        priority: 3
      }),
      Logs.create_sms_log(%{
        messages: msg6.id,
        operators: operator1.id,
        statuses: status1.id,
        priority: 1
      }),
      Logs.create_sms_log(%{
        messages: msg6.id,
        operators: operator2.id,
        statuses: status2.id,
        priority: 2
      }),
      Logs.create_sms_log(%{
        messages: msg6.id,
        operators: operator5.id,
        statuses: status3.id,
        priority: 3
      }),
      Logs.create_sms_log(%{
        messages: msg2.id,
        operators: operator1.id,
        statuses: status1.id,
        priority: 1
      }),
      Logs.create_sms_log(%{
        messages: msg5.id,
        operators: operator1.id,
        statuses: status1.id,
        priority: 1
      }),
      Logs.create_sms_log(%{
        messages: msg5.id,
        operators: operator1.id,
        statuses: status1.id,
        priority: 1
      })
    ]
  end
end
