defmodule Handan.Purchasing.Projections.PurchaseOrderItem do
  @moduledoc """
  Purchase Order Item
  """

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "purchase_order_items" do
    field :item_name, :string
    field :stock_uom_uuid, :binary_id
    field :unit_price, :decimal
    field :amount, :decimal, default: 0
    field :uom_name, :string
    field :ordered_qty, :decimal, default: 0
    field :received_qty, :decimal, default: 0
    field :remaining_qty, :decimal, default: 0

    belongs_to :purchase_order, Handan.Purchasing.Projections.PurchaseOrder, foreign_key: :purchase_order_uuid, references: :uuid
    belongs_to :item, Handan.Inventory.Projections.Item, foreign_key: :item_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
