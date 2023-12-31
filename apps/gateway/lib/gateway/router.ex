defmodule Gateway.Router do
  use Gateway, :router

  alias Absinthe.{
    Plug,
    Plug.GraphiQL
  }

  alias Gateway.{
    Context,
    GraphQL.Schema
  }

  pipeline :api do
    plug Context
    plug :accepts, ["json"]
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
      schemes: ["http", "https"],
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
        %{name: "Home", description: "Single page with status"},
      ]
    }
  end
end
