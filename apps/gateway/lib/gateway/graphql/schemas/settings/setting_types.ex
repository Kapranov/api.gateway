defmodule Gateway.GraphQL.Schemas.Settings.SettingTypes do
  @moduledoc """
  The Setting GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias Gateway.GraphQL.Resolvers.Settings.SettingResolver

  @desc "The setting on the site"
  object :setting do
    field :id, :string, description: "setting id"
    field :param, :string, description: "param string data type"
    field :value, :string, description: "value string data type"
    field :error, :integer, description: "number report errors"
    field :error_description, :string, description: "report errors when something wrong"
    field :inserted_at, :date, description: "timestamps by DB"
    field :updated_at, :date, description: "timestamps by DB"
  end

  @desc "The Setting updated via params"
  input_object :update_setting_params, description: "update model's setting" do
    field :param, :string
    field :value, :string
  end

  object :setting_queries do
    @desc "The list all records for model's Settings"
    field :list_setting, list_of(:setting) do
      resolve(&SettingResolver.list/3)
    end

    @desc "Get one record for model's settings"
    field :show_setting, :setting do
      arg(:id, non_null(:string))
      resolve(&SettingResolver.show/3)
    end
  end

  object :setting_mutations do
    @desc "Created the model's settings"
    field :create_setting, :setting, description: "Created a new record for model's settings" do
      arg :param, non_null(:string)
      arg :value, non_null(:string)
      resolve &SettingResolver.create/3
    end

    @desc "Updated a specific recored for model's Settings"
    field :update_setting, :setting, description: "Updated a one record for model's settings" do
      arg :id, non_null(:string)
      arg :setting, :update_setting_params
      resolve &SettingResolver.update/3
    end
  end
end