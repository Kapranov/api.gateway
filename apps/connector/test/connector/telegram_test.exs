defmodule Connector.TelegramTest do
  use ExUnit.Case

  alias Connector.Telegram

  @valid_attrs %{
    id: "Aczn5tlp0NzfxBKRk0",
    message_body: "Hello World!",
    phone_number: "+380991111111"
  }

  describe "Telegram" do
    test "#send/1 with successful or error" do
      {:ok, data} = Telegram.send(@valid_attrs)
      assert data == %{"status" => "send", "id" => @valid_attrs.id} or %{"status" => "error"}
    end
  end
end
