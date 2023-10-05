defmodule Gateway.GraphQL.Schemas.Monitoring.StatusTypes do
  @moduledoc """
  The Status GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Gateway.GraphQL.{
    Data,
    Resolvers.Monitoring.StatusResolver
  }

  @desc "The Statuses on the site"
  object :status do
    field :id, non_null(:string), description: "status id"
    field :active, non_null(:boolean), description: "active boolean data type"
    field :description, :string, description: "description string data type"
    field :sms_logs, list_of(:sms_logs), resolve: dataloader(Data), description: "smsLogs is list records by SmsLogs"
    field :status_code, non_null(:integer), description: "status code is integer data type"
    field :status_name, non_null(:string), description: "status nameis string data type"
    field :inserted_at, non_null(:datetime), description: "timestamps by DB"
  end

  object :status_queries do
    @desc "The list all records for model's Statuses"
    field :list_status, list_of(:status) do
      resolve(&StatusResolver.list/3)
    end

    @desc "Get one record for model's Statuses"
    field :show_status, :status do
      arg(:id, non_null(:string))
      resolve(&StatusResolver.show/3)
    end
  end

  object :status_mutations do
    @desc "Created the model's Statuses"
    field :create_status, :status, description: "Created a new record for model's Statuses" do
      arg :active, non_null(:boolean)
      arg :description, :string
      arg :status_code, non_null(:integer)
      arg :status_name, non_null(:string)
      resolve &StatusResolver.create/3
    end
  end
end
