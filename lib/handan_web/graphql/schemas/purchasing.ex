defmodule HandanWeb.GraphQL.Schemas.Purchasing do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  alias Handan.Purchasing

  object :supplier do
    field :uuid, :id
    field :name, :string
    field :address, :string
  end

  object :purchase_order do
    field :uuid, :id
    field :status, :string
    field :receipt_status, :string
    field :billing_status, :string
    field :supplier_name, :string
    field :supplier_address, :string
    field :total_amount, :decimal
    field :paid_amount, :decimal
    field :remaining_amount, :decimal
    field :total_qty, :decimal
    field :received_qty, :decimal
    field :remaining_qty, :decimal
  end

  object :purchase_order_item do
    field :uuid, :id
    field :item_name, :string
    field :stock_uom_uuid, :id
    field :unit_price, :decimal
    field :amount, :decimal
    field :uom_name, :string
    field :ordered_qty, :decimal
    field :received_qty, :decimal
    field :remaining_qty, :decimal
  end

  object :purchase_invoice do
    field :uuid, :id
    field :purchase_order_uuid, :id
    field :item_name, :string
    field :stock_uom_uuid, :id
    field :unit_price, :decimal
    field :amount, :decimal
    field :uom_name, :string
    field :ordered_qty, :decimal
    field :received_qty, :decimal
    field :remaining_qty, :decimal
  end

  object :purchase_invoice_item do
    field :uuid, :id
    field :purchase_order_uuid, :id
    field :item_name, :string
    field :stock_uom_uuid, :id
    field :unit_price, :decimal
    field :amount, :decimal
    field :uom_name, :string
    field :ordered_qty, :decimal
    field :received_qty, :decimal
    field :remaining_qty, :decimal
  end

  object :receipt_note do
    field :uuid, :id
    field :supplier_name, :string
    field :total_amount, :decimal
    field :total_qty, :decimal
    field :status, :string
  end

  object :receipt_note_item do
    field :uuid, :id
    field :item_name, :string
    field :uom_name, :string
    field :stock_uom_uuid, :id
    field :unit_price, :decimal
    field :amount, :decimal
    field :actual_qty, :decimal
  end

  # object :purchase_queries do
  # end

  # object :purchase_mutations do
  # end
end
