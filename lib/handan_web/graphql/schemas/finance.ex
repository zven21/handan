defmodule HandanWeb.GraphQL.Schemas.Finance do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  alias Handan.Finance

  object :payment_entry do
    field :uuid, :id
    field :memo, :string
    field :attachments, list_of(:string)
    field :party_name, :string
    field :party_type, :string
    field :party_uuid, :id
    field :purchase_invoice_ids, list_of(:string)
    field :sales_invoice_ids, list_of(:string)
    field :total_amount, :decimal

    field :payment_method, :payment_method, resolve: dataloader(Finance, :payment_method)
  end

  object :payment_method do
    field :uuid, :id
    field :name, :string
  end

  object :finance_queries do
    @desc "list payment entries"
    field :payment_entries, list_of(:payment_entry) do
      resolve(fn args, _ -> {:ok, []} end)
    end

    @desc "get payment entry"
    field :payment_entry, :payment_entry do
      resolve(fn args, _ -> {:ok, %{}} end)
    end

    @desc "list payment methods"
    field :payment_methods, list_of(:payment_method) do
      resolve(fn args, _ -> {:ok, []} end)
    end

    @desc "get payment method"
    field :payment_method, :payment_method do
      resolve(fn args, _ -> {:ok, %{}} end)
    end
  end

  object :finance_mutations do
    @desc "create payment entry"
    field :create_payment_entry, :payment_entry do
      resolve(fn args, _ -> {:ok, %{}} end)
    end

    @desc "create payment method"
    field :create_payment_method, :payment_method do
      resolve(fn args, _ -> {:ok, %{}} end)
    end
  end
end
