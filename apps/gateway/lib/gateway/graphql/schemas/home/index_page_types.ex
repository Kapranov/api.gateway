defmodule Gateway.GraphQL.Schemas.Home.IndexPageTypes do
  @moduledoc """
  The single page GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias Gateway.GraphQL.Resolvers.Home.IndexPageResolver

  @desc "The page with status"
  object :page do
    field :status, non_null(:string)
  end

  @desc "Its generationed token"
  object :access do
    field :access_token, non_null(:string)
  end

  object :index_page_queries do
    @desc "Get index page"
    field :index_page, :page do
      resolve(&IndexPageResolver.public/3)
    end

    @desc "Get index page via authorization"
    field :home_page, :page do
      resolve(&IndexPageResolver.index/3)
    end

    @desc "The generation token"
    field :get_token, :access do
      resolve(&IndexPageResolver.token/3)
    end
  end
end
