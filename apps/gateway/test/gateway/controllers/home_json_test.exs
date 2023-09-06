defmodule Gateway.HomeJSONTest do
  use Gateway.ConnCase, async: true

  test "renders 200" do
    assert Gateway.HomeJSON.render("home.json", %{}) == %{status: "working"}
  end
end

