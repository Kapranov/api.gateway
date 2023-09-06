defmodule Gateway.HomeControllerTest do
  use Gateway.ConnCase, async: true

  setup do
    conn = build_conn() |> put_req_header("accept", "application/json; charset=utf-8")
    {:ok, conn: conn}
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert json_response(conn, 200)
  end
end
