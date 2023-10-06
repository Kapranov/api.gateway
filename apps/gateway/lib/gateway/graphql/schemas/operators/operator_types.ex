defmodule Gateway.GraphQL.Schemas.Operators.OperatorTypes do
  @moduledoc """
  The Operators GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Gateway.GraphQL.{
    Data,
    Resolvers.Operators.OperatorResolver
  }

  @desc "The operators on the site"
  object :operator do
    field :id, non_null(:string), description: "operator id"
    field :active, non_null(:boolean), description: "active is boolean data type"
    field :config, non_null(:config), description: "config is map with nested parameters data type"
    field :limit_count, :integer, description: "limit_count is integer data type"
    field :name_operator, non_null(:string), description: "name_operator is string data type"
    field :operator_type, non_null(:operator_type), resolve: dataloader(Data)
    field :phone_code, :string, description: "phone_code is string data type"
    field :price_ext, non_null(:decimal), description: "price_ext is float data type"
    field :price_int, non_null(:decimal), description: "price_int is float data type"
    field :priority, non_null(:integer), description: "priority is integer data type"
    field :sms_logs, list_of(:sms_logs), resolve: dataloader(Data), description: "smsLogs is list records by SmsLogs"
    field :inserted_at, non_null(:datetime), description: "timestamps by DB"
    field :updated_at, non_null(:datetime), description: "timestamps by DB"
  end

  @desc "The config map"
  object :config do
    field :id, non_null(:string), description: "config id"
    field :content_type, :string, description: "content_type is string data type"
    field :name, non_null(:string), description: "name is string data type"
    field :parameters, non_null(:parameters), description: "parameters is struct data type"
    field :size, :integer, description: "size is integer data type"
    field :url, non_null(:string), description: "url is string data type"
    field :inserted_at, non_null(:datetime), description: "timestamps by DB"
    field :updated_at, non_null(:datetime), description: "timestamps by DB"
  end

  @desc "The parameters map"
  object :parameters do
    field :id, non_null(:string), description: "parameters id"
    field :key, non_null(:string), description: "key is string data type"
    field :value, non_null(:string), description: "value is string data type"
    field :inserted_at, non_null(:datetime), description: "timestamps by DB"
    field :updated_at, non_null(:datetime), description: "timestamps by DB"
  end

  @desc "The operator updated via params"
  input_object :update_operator_params, description: "update model's operators" do
    field :active, :boolean
    field :config, :update_config
    field :limit_count, :integer
    field :name_operator, :string
    field :operator_type_id, :string
    field :phone_code, :string
    field :price_ext, :decimal
    field :price_int, :decimal
    field :priority, :integer
  end

  @desc "The config updated via params"
  input_object :update_config do
    field :content_type, :string, description: "content_type is string data type"
    field :name, :string, description: "name is string data type"
    field :parameters, non_null(:update_parameters), description: "parameters is struct data type"
    field :size, :integer, description: "size is integer data type"
    field :url, :string, description: "url is string data type"
  end

  @desc "The parameters updated via params"
  input_object :update_parameters do
    field :key, :string, description: "key is string data type"
    field :value, :string, description: "value is string data type"
  end

  object :operator_queries do
    @desc "The list all records for model's Operators"
    field :list_operator, list_of(:operator) do
      resolve(&OperatorResolver.list/3)
    end

    @desc "Get one record for model's Operators"
    field :show_operator, list_of(:operator) do
      arg(:id, non_null(:string))
      resolve(&OperatorResolver.show/3)
    end
  end

  object :operator_mutations do
    @desc "Created the model's operators"
    field :create_operator, list_of(:operator), description: "Created a new record for model's operators" do
      arg :active, non_null(:boolean)
      arg :config, non_null(:update_config)
      arg :limit_count, :integer
      arg :name_operator, non_null(:string)
      arg :operator_type_id, non_null(:string)
      arg :phone_code, :string
      arg :price_ext, non_null(:decimal)
      arg :price_int, non_null(:decimal)
      arg :priority, non_null(:integer)
      resolve &OperatorResolver.create/3
    end

    @desc "Updated a specific recored for model's operators"
    field :update_operator, list_of(:operator), description: "Updated a one record for model's operators" do
      arg :id, non_null(:string)
      arg :operator, :update_operator_params
      resolve &OperatorResolver.update/3
    end
  end
end
