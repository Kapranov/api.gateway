defmodule Gateway.GraphQL.Schemas.Home.HomeTypes do
  @moduledoc """
  The home GraphQL interface.
  """

  use Absinthe.Schema.Notation

  object :home do
    field :status, non_null(:string)
  end
end
