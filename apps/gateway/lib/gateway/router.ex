defmodule Gateway.Router do
  use Gateway, :router

  alias Absinthe.{
    Plug,
    Plug.GraphiQL
  }

  alias Gateway.GraphQL.Schema

  pipeline :api do
    plug :accepts, ["json"]
    plug :inspect_conn, []
  end

  scope "/api", Gateway do
    pipe_through :api

    get "/", HomeController, :index
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :gateway,
      swagger_file: "swagger.json"
  end

  scope "/" do
    pipe_through :api

    if Mix.env() == :dev || :test do
      forward "/graphiql", GraphiQL,
        analyze_complexity: true,
        max_complexity: 200,
        interface: :advanced,
        json_codec: Jason,
        schema: Schema
    end

    forward "/", Plug, schema: Schema
  end

  def swagger_info do
    %{
      schemes: ["http", "https", "ws", "wss"],
      info: %{
        version: "1.0",
        title: "GatewayAPI",
        description: "API Documentation for GatewayAPI v1",
        termsOfService: "Open for public",
        contact: %{
          name: "Oleg G.Kapranov",
          email: "oleg.kapranov@ehealth.gov.ua"
        }
      },
      securityDefinitions: %{
        Bearer: %{
          type: "apiKey",
          name: "Authorization",
          description: "API Token must be provided via `Authorization: Bearer ` header",
          in: "header"
        }
      },
      consumes: ["application/json"],
      produces: ["application/json"],
      tags: [
        %{name: "Home", description: "Single empty page"},
      ]
    }
  end

  def inspect_conn(conn, _) do
    "\n" |> IO.inspect()
    IO.inspect("#{inspect(conn.params)}")
    conn.request_path |> IO.inspect(label: :path)
    conn.params["operationName"] |> IO.inspect(label: :operationName)
    :io.format("~nquery: ~n~s~n", [conn.params["query"]])
    conn.params["variables"] |> IO.inspect(label: :variables)

    conn
  end
end
