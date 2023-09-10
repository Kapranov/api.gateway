defmodule Gateway.GraphQL.Integration.Home.IndexPageIntegrationTest do
  use Gateway.ConnCase

  alias Gateway.{
    AbsintheHelpers,
    Endpoint,
    GraphQL.Schema
  }

  @phrase Application.compile_env(:gateway, Endpoint)[:phrase]

  describe "#indexPage" do
    test "returns index page without authorization's token" do
      query = """
      {
        indexPage { status }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "indexPage"))

      assert json_response(res, 200)["errors"] == nil
      data = json_response(res, 200)["data"]["indexPage"]
      assert data["status"] == "working"
    end
  end

  describe "#homePage" do
    test "returns home page with authorization's token" do
      query = """
      {
        homePage { status }
      }
      """
      res =
        build_conn()
        |> auth_conn(@phrase)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "homePage"))

      assert json_response(res, 200)["errors"] == nil
      data = json_response(res, 200)["data"]["homePage"]
      assert data["status"] == "working"
    end
  end

  describe "#getToken" do
    test "returns generated token" do
      query = """
      {
        getToken { accessToken }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getToken"))

      assert json_response(res, 200)["errors"] == nil
      data = json_response(res, 200)["data"]["getToken"]
      assert data["accessToken"] =~ "SFM"
    end
  end

  describe "#indexPage via Schema" do
    test "returns index page without authorization's token via schema" do
      context = []

      query = """
      {
        indexPage { status }
      }
      """
      {:ok, %{data: %{"indexPage" => data}}} = Absinthe.run(query, Schema, context)
      assert data["status"] == "working"
    end
  end

  describe "#homePage via Schema" do
    test "returns home page with authorization's token via schema" do
      context = %{token: @phrase}

      query = """
      {
        homePage { status }
      }
      """
      {:ok, %{data: %{"homePage" => data}}} = Absinthe.run(query, Schema, context: context)
      assert data["status"] == "working"
    end
  end

  describe "#getToken via Schema" do
    test "returns generated token via schema" do
      context = []

      query = """
      {
        getToken { accessToken }
      }
      """
      {:ok, %{data: %{"getToken" => data}}} = Absinthe.run(query, Schema, context)
      assert data["accessToken"] =~ "SFM"
    end
  end
end
