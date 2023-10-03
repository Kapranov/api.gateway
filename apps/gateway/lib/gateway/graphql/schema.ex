defmodule Gateway.GraphQL.Schema do
  @moduledoc """
  The GraphQL schema.
  """

  use Absinthe.Schema

  alias Absinthe.{
    Middleware,
    Plugin
  }

  alias Gateway.GraphQL.Data

  import_types(Absinthe.Plug.Types)
  import_types(Absinthe.Type.Custom)
  import_types(Gateway.GraphQL.Schemas.Home.IndexPageTypes)
  import_types(Gateway.GraphQL.Schemas.Logs.SmsLogTypes)
  import_types(Gateway.GraphQL.Schemas.Monitoring.StatusTypes)
  import_types(Gateway.GraphQL.Schemas.Operators.OperatorTypeTypes)
  import_types(Gateway.GraphQL.Schemas.Settings.SettingTypes)
  import_types(Gateway.GraphQL.Schemas.UuidTypes)

  @desc "The root query type."
  query do
    import_fields(:index_page_queries)
    import_fields(:operator_type_queries)
    import_fields(:setting_queries)
    import_fields(:sms_log_queries)
    import_fields(:status_queries)
  end

  @desc "The root mutation type."
  mutation do
    import_fields(:operator_type_mutations)
    import_fields(:setting_mutations)
    import_fields(:sms_log_mutations)
    import_fields(:status_mutations)
  end

  @spec context(map()) :: map()
  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Data, Data.data())

    Map.put(ctx, :loader, loader)
  end

  @spec plugins() :: list()
  def plugins do
    [Middleware.Dataloader] ++ Plugin.defaults()
  end

  @spec middleware(list(), any(), any()) :: list()
  def middleware(middleware, field, object) do
    middleware
    |> apply(:errors, field, object)
    |> apply(:get_string, field, object)
    |> apply(:debug, field, object)
  end

  @spec apply(list(), atom(), any(), map()) :: list()
  defp apply(middleware, :errors, _field, %{identifier: :mutation}) do
    middleware ++ [Gateway.GraphQL.Schemas.Middleware.ChangesetErrors] ++
      [Gateway.GraphQL.Helpers.ErrorHelper]
  end

  defp apply(middleware, :get_string, field, %{identifier: :name} = object) do
    new_middleware = {Absinthe.Middleware.MapGet, to_string(field.identifier)}

    middleware
    |> Absinthe.Schema.replace_default(new_middleware, field, object)
  end

  defp apply(middleware, :debug, _field, _object) do
    if System.get_env("DEBUG") do
      [{Middleware.Debug, :start}] ++ middleware
    else
      middleware
    end
  end

  defp apply(middleware, _, _, _) do
    middleware ++ [Gateway.GraphQL.Schemas.Middleware.ChangesetErrors] ++
      [Gateway.GraphQL.Helpers.ErrorHelper]
  end
end
