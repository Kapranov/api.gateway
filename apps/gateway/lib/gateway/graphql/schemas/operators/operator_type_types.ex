defmodule Gateway.GraphQL.Schemas.Operators.OperatorTypeTypes do
  @moduledoc """
  The OperatorTypes GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias Gateway.GraphQL.Resolvers.Operators.OperatorTypeResolver

  @desc "The operatorTypes on the site"
  object :operator_type do
    field :id, non_null(:string), description: "operator type id"
    field :active, non_null(:boolean), description: "active is boolean data type"
    field :name_type, non_null(:string), description: "name type is string data type"
    field :priority, :integer, description: "priority is integer data type"
    field :inserted_at, non_null(:datetime), description: "timestamps by DB"
    field :updated_at, non_null(:datetime), description: "timestamps by DB"
  end

  @desc "The operatorType updated via params"
  input_object :update_operator_type_params, description: "update model's operatorTypes" do
    field :active, :boolean
    field :name_type, :string
    field :priority, :integer
  end

  object :operator_type_queries do
    @desc "The list all records for model's OperatorTypes"
    field :list_operator_type, list_of(:operator_type) do
      resolve(&OperatorTypeResolver.list/3)
    end

    @desc "Get one record for model's OperatorTypes"
    field :show_operator_type, list_of(:operator_type) do
      arg(:id, non_null(:string))
      resolve(&OperatorTypeResolver.show/3)
    end
  end

  object :operator_type_mutations do
    @desc "Created the model's operatorTypes"
    field :create_operator_type, list_of(:operator_type), description: "Created a new record for model's operatorTypes" do
      arg :active, non_null(:boolean)
      arg :name_type, non_null(:string)
      arg :priority, :integer
      resolve &OperatorTypeResolver.create/3
    end

    @desc "Updated a specific recored for model's operatorTypes"
    field :update_operator_type, list_of(:operator_type), description: "Updated a one record for model's operatorTypes" do
      arg :id, non_null(:string)
      arg :operator_type, :update_operator_type_params
      resolve &OperatorTypeResolver.update/3
    end
  end
end
