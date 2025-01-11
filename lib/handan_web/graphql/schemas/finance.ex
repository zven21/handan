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

  # object :finance_queries do
  # end

  # object :finance_mutations do
  # end
end
