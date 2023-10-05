defmodule Gateway.GraphQL.Schemas.Settings.SettingTypes do
  @moduledoc """
  The Setting GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias Gateway.GraphQL.Resolvers.Settings.SettingResolver

  @desc "The Settings on the site"
  object :setting do
    field :id, non_null(:string), description: "settings id"
    field :param, non_null(:string), description: "param string data type"
    field :value, non_null(:string), description: "value string data type"
    field :inserted_at, non_null(:datetime), description: "timestamps by DB"
    field :updated_at, non_null(:datetime), description: "timestamps by DB"
  end

  @desc "The Setting updated via params"
  input_object :update_setting_params, description: "update model's Settings" do
    field :param, :string
    field :value, :string
  end

  object :setting_queries do
    @desc "The list all records for model's Settings"
    field :list_setting, list_of(:setting) do
      resolve(&SettingResolver.list/3)
    end

    @desc "Get one record for model's Settings"
    field :show_setting, :setting do
      arg(:id, non_null(:string))
      resolve(&SettingResolver.show/3)
    end
  end

  object :setting_mutations do
    @desc "Created the model's Settings"
    field :create_setting, :setting, description: "Created a new record for model's Settings" do
      arg :param, non_null(:string)
      arg :value, non_null(:string)
      resolve &SettingResolver.create/3
    end

    @desc "Updated a specific recored for model's Settings"
    field :update_setting, :setting, description: "Updated a one record for model's Settings" do
      arg :id, non_null(:string)
      arg :setting, :update_setting_params
      resolve &SettingResolver.update/3
    end
  end
end
