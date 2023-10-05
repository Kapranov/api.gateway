defmodule Gateway.GraphQL.Schemas.Logs.SmsLogTypes do
  @moduledoc """
  The SmsLog GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Gateway.GraphQL.{
    Data,
    Resolvers.Logs.SmsLogResolver
  }

  @desc "The SmsLogs on the site"
  object :sms_logs do
    field :id, non_null(:string), description: "smsLogs id"
    field :priority, non_null(:integer), description: "priority is an integer data type"
    field :statuses, list_of(:status), resolve: dataloader(Data), description: "statuses is list records by Statuses"
    field :messages, list_of(:message), resolve: dataloader(Data), description: "messages is list records by Messages"
    field :operators, list_of(:operator), resolve: dataloader(Data), description: "operators is list records by Operators"
    field :inserted_at, non_null(:datetime), description: "timestamps by DB"
  end

  object :sms_log_queries do
    @desc "Get one record for model's smsLogs"
    field :show_sms_log, :sms_logs do
      arg(:id, non_null(:string))
      resolve(&SmsLogResolver.show/3)
    end
  end

  object :sms_log_mutations do
    @desc "Created the model's smsLogs"
    field :create_sms_log, :sms_logs, description: "Created a new record for model's smsLogs" do
      arg :priority, non_null(:integer)
      arg :message_id, non_null(:string)
      arg :operator_id, non_null(:string)
      arg :status_id, non_null(:string)
      resolve &SmsLogResolver.create/3
    end
  end
end
