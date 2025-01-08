defmodule Handan.Purchasing.Projections.ReceiptNoteItem do
  @moduledoc """
  Receipt Note Item
  """

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "receipt_note_items" do
    field :item_name, :string
    field :uom_name, :string
    field :unit_price, :decimal
    field :amount, :decimal
    field :actual_qty, :decimal

    belongs_to :receipt_note, Handan.Purchasing.Projections.ReceiptNote, foreign_key: :receipt_note_uuid, references: :uuid
    belongs_to :item, Handan.Inventory.Projections.Item, foreign_key: :item_uuid, references: :uuid
    belongs_to :purchase_order_item, Handan.Purchasing.Projections.PurchaseOrderItem, foreign_key: :purchase_order_item_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
