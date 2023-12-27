defmodule Gateway.GraphQL.Schemas.Spring.MessageTypes do
  @moduledoc """
  The Message GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Gateway.GraphQL.Resolvers.Spring.MessageResolver

  alias Gateway.GraphQL.{
    Data,
    Resolvers.Spring.MessageResolver
  }

  @desc "The Messages on the site"
  object :message do
    field :id, non_null(:string), description: "messages id"
    field :id_external, :string, description: "idExternal is string data type"
    field :id_tax, :integer, description: "idTax is integer data type"
    field :id_telegram, :string, description: "idTelegram is string data type"
    field :message_body, non_null(:string), description: "messageBody is string data type"
    field :message_expired_at, :datetime, description: "messageExpiredAt is timestamps data type"
    field :phone_number, non_null(:string), description: "phoneNumber is string data type"
    field :sms_logs, list_of(:sms_logs), resolve: dataloader(Data), description: "smsLogs is list records by SmsLogs"
    field :status, list_of(:status), resolve: dataloader(Data), description: "ststus is list records by Status"
    field :status_changed_at, :datetime, description: "statusChangedAt is timestamps"
    field :status_id, non_null(:string), description: "statusId is records by Status"
    field :inserted_at, non_null(:datetime), description: "timestamps by DB"
    field :updated_at, non_null(:datetime), description: "timestamps by DB"
  end

  @desc "The Message updated via params"
  input_object :update_message_params, description: "update model's Messages" do
    field :id_external, :string
    field :id_tax, :integer
    field :id_telegram, :string
    field :message_body, :string
    field :message_expired_at, :datetime
    field :phone_number, :string
    field :status_changed_at, :datetime
    field :status_id, :string
  end

  object :message_queries do
    @desc "Get one record for model's Messages"
    field :show_message, list_of(:message) do
      arg(:id, non_null(:string))
      resolve(&MessageResolver.show/3)
    end

    @desc "List Operators by Message's phoneNumber"
    field :sorted_operators, list_of(:operator) do
      arg(:phone_number, non_null(:string))
      resolve(&MessageResolver.sorted_operators/3)
    end
  end

  object :message_mutations do
    @desc "Created the model's Messages"
    field :create_message, list_of(:message), description: "Created a new record for model's Messages" do
      arg :id_external, :string
      arg :id_tax, :integer
      arg :id_telegram, :string
      arg :message_body, non_null(:string)
      arg :message_expired_at, :datetime
      arg :phone_number, non_null(:string)
      arg :status_changed_at, :datetime
      arg :status_id, non_null(:string)
      resolve &MessageResolver.create/3
    end

    @desc "Created the model's Messages via monitor's kafka"
    field :create_message_via_monitor, list_of(:message), description: "Created a new record for model's Messages and send via motinor's kafka" do
      arg :id_external, :string
      arg :id_tax, :integer
      arg :id_telegram, :string
      arg :message_body, non_null(:string)
      arg :message_expired_at, :datetime
      arg :phone_number, non_null(:string)
      arg :status_changed_at, :datetime
      arg :status_id, non_null(:string)
      resolve &MessageResolver.create_via_monitor/3
    end

    @desc "Created the model's Messages via kafka"
    field :create_message_via_kafka, list_of(:message), description: "Created a new record for model's Messages and send via kafka" do
      arg :id_external, :string
      arg :id_tax, :integer
      arg :id_telegram, :string
      arg :message_body, non_null(:string)
      arg :message_expired_at, :datetime
      arg :phone_number, non_null(:string)
      arg :status_changed_at, :datetime
      arg :status_id, non_null(:string)
      resolve &MessageResolver.create_via_kafka/3
    end

    @desc "Created the model's Messages via sorted operator's connector"
    field :create_message_via_connector, list_of(:message), description: "Created a new record for model's Messages and send via sorted connectors" do
      arg :id_external, :string
      arg :id_tax, :integer
      arg :id_telegram, :string
      arg :message_body, non_null(:string)
      arg :message_expired_at, :datetime
      arg :phone_number, non_null(:string)
      arg :status_changed_at, :datetime
      arg :status_id, non_null(:string)
      resolve &MessageResolver.create_via_connector/3
    end

    @desc "Created the model's Messages via multi"
    field :create_message_via_multi, list_of(:message), description: "Created a new record for model's Messages via multi" do
      arg :id_external, :string
      arg :id_tax, :integer
      arg :id_telegram, :string
      arg :message_body, non_null(:string)
      arg :message_expired_at, :datetime
      arg :phone_number, non_null(:string)
      arg :status_changed_at, :datetime
      arg :status_id, non_null(:string)
      resolve &MessageResolver.create_via_multi/3
    end

    @desc "Created the model's Messages via selected operator's connector"
    field :create_message_via_selected, list_of(:message), description: "Created a new record for model's Messages and send via selected connectors" do
      arg :id_external, :string
      arg :id_tax, :integer
      arg :id_telegram, :string
      arg :message_body, non_null(:string)
      arg :message_expired_at, :datetime
      arg :phone_number, non_null(:string)
      arg :status_changed_at, :datetime
      arg :status_id, non_null(:string)
      resolve &MessageResolver.create_via_selected/3
    end

    @desc "Updated a specific recored for model's Messages"
    field :update_message, list_of(:message), description: "Updated a one record for model's Messages" do
      arg :id, non_null(:string)
      arg :message, :update_message_params
      resolve &MessageResolver.update/3
    end
  end
end
