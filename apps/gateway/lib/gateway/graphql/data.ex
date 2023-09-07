defmodule Gateway.GraphQL.Data do
  @moduledoc """
  A single Dataloader struct can have many different sources,
  which represent different ways to load data, provides an easy
  way efficiently load data in batches.
  """

  import Ecto.Query

  alias Core.Repo
  alias Dataloader.Ecto

  @type t :: %Dataloader{
    sources: %{source_name => Dataloader.Source.t()},
    options: [option]
  }

  @type option :: {:timeout, pos_integer} | {:get_policy, atom()}
  @type source_name :: any

  @spec data() :: t()
  def data do
    Ecto.new(Repo, query: &query/2)
  end

  @spec query(map(), map()) :: map()
  def query(queryable, params) do
    case Map.get(params, :order_by) do
      nil -> queryable
      order_by -> from record in queryable, order_by: ^order_by
    end
  end
end
