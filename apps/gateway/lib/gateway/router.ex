defmodule Gateway.Router do
  use Gateway, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Gateway do
    pipe_through :api
  end
end
