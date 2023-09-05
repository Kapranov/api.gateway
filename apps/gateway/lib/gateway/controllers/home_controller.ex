defmodule Gateway.HomeController do
  use Gateway, :controller
  use PhoenixSwagger

  swagger_path :index do
    get "/"
    description "Home page with status is working"
    response 200, "Success"
  end

  def index(conn, _params) do
    render(conn, :index)
  end
end
