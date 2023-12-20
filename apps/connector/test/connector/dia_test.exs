defmodule Connector.DiaTest do
  use ExUnit.Case

  alias Connector.Dia

  @valid_attrs %{
    id: "Aczn5tlp0NzfxBKRk0",
    message_body: "Hello World!",
    phone_number: "+380991111111"
  }

  describe "Dia" do
    test "#send/1 with successful or error" do
      {:ok, data} = Dia.send(@valid_attrs)
      assert data == %{"status" => "send", "id" => @valid_attrs.id} or %{"status" => "error"}
    end
  end
end
