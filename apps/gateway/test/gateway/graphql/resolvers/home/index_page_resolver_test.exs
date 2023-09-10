defmodule Gateway.GraphQL.Resolvers.Home.IndexPageResolverTest do
  use Gateway.ConnCase

  alias Gateway.GraphQL.Resolvers.Home.IndexPageResolver

  describe "#public" do
    test "returns index page without authorization's token" do
      {:ok, data} = IndexPageResolver.public(nil, nil, nil)
      assert length([data]) == 1
      assert data.status == "working"
    end
  end

  describe "#index" do
    test "returns error an authorization's token" do
      {:error, data} = IndexPageResolver.index(nil, nil, nil)
      assert data == [[field: :token, message: "Unauthenticated"]]
    end

    test "returns index page with authorization's token" do
      context = %{context: %{token: "token_phrase"}}
      {:ok, data} = IndexPageResolver.index(nil, nil, context)
      assert length([data]) == 1
      assert data.status == "working"
    end
  end

  describe "#token" do
    test "returns successfully generated token" do
      {:ok, data} = IndexPageResolver.token(nil, nil, nil)
      assert length([data]) == 1
      assert data.access_token =~ "SFM"
    end
  end
end
