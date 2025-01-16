defmodule HandanWeb.GraphQL.Schemas.Finance do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]
  import HandanWeb.GraphQL.Helpers.Fields, only: [timestamp_fields: 0]

  alias Handan.Finance

  object :payment_entry do
    field :uuid, :id
    field :code, :string
    field :memo, :string
    field :attachments, list_of(:string)
    field :party_name, :string
    field :party_type, :string
    field :party_uuid, :id
    field :purchase_invoice_ids, list_of(:string)
    field :sales_invoice_ids, list_of(:string)
    field :total_amount, :decimal
    field :payment_method_uuid, :id

    field :payment_method, :payment_method, resolve: dataloader(Finance, :payment_method)

    timestamp_fields()
  end

  object :payment_method do
    field :uuid, :id
    field :name, :string

    timestamp_fields()
  end

  object :finance_queries do
    @desc "list payment entries"
    field :payment_entries, list_of(:payment_entry) do
      middleware(M.Authorize, :user)
      resolve(&R.Finance.list_payment_entries/2)
    end

    @desc "get payment entry"
    field :payment_entry, :payment_entry do
      arg(:request, non_null(:id_request))

      middleware(M.Authorize, :user)
      resolve(&R.Finance.get_payment_entry/2)
    end

    @desc "list payment methods"
    field :payment_methods, list_of(:payment_method) do
      middleware(M.Authorize, :user)
      resolve(&R.Finance.list_payment_methods/2)
    end

    @desc "get payment method"
    field :payment_method, :payment_method do
      arg(:request, non_null(:id_request))

      middleware(M.Authorize, :user)
      resolve(&R.Finance.get_payment_method/2)
    end
  end

  object :finance_mutations do
    @desc "create payment entry"
    field :create_payment_entry, :payment_entry do
      arg(:request, non_null(:create_payment_entry_request))

      middleware(M.Authorize, :user)

      resolve(&R.Finance.create_payment_entry/3)
    end

    @desc "create payment method"
    field :create_payment_method, :payment_method do
      arg(:request, non_null(:create_payment_method_request))

      middleware(M.Authorize, :user)

      resolve(&R.Finance.create_payment_method/3)
    end
  end

  input_object :create_payment_entry_request do
    field :party_type, non_null(:string)
    field :party_uuid, non_null(:id)
    field :payment_method_uuid, non_null(:id)
    field :purchase_invoice_ids, list_of(:id)
    field :sales_invoice_ids, list_of(:id)
    field :total_amount, :float
    field :memo, :string
    field :attachments, list_of(:string)
  end

  input_object :create_payment_method_request do
    field :name, :string
  end
end
