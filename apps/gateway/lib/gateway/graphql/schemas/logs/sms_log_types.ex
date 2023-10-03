defmodule Gateway.GraphQL.Schemas.Logs.SmsLogTypes do
  @moduledoc """
  The SmsLog GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias Gateway.GraphQL.Resolvers.Logs.SmsLogResolver

  @desc "The SmsLogs on the site"
  object :sms_logs do
    field :id, :string, description: "smsLogs id"
    field :priority, :integer, description: "priority is an integer data type"
    field :statuses, list_of(:status)
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
      resolve &SmsLogResolver.create/3
    end
  end
end
