defmodule Core.Seeder.Updated.Logs do
  @moduledoc """
  An update are seeds whole the logs.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_sms_log()
    IO.puts("Updated data on model's SmsLog\n")
  end

  @spec update_sms_log() :: Ecto.Schema.t()
  defp update_sms_log do
    :ok
  end
end
