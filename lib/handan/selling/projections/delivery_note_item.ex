defmodule Handan.Selling.Projections.DeliveryNoteItem do
  @moduledoc false
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "delivery_note_items" do
    field :actual_qty, :decimal
    field :amount, :decimal
    field :unit_price, :decimal
    field :item_name, :string

    belongs_to :delivery_note, Handan.Selling.Projections.DeliveryNote, foreign_key: :delivery_note_uuid, references: :uuid
    belongs_to :sales_order, Handan.Selling.Projections.SalesOrder, foreign_key: :sales_order_uuid, references: :uuid
    belongs_to :sales_order_item, Handan.Selling.Projections.SalesOrderItem, foreign_key: :sales_order_item_uuid, references: :uuid
    belongs_to :item, Handan.Stock.Projections.Item, foreign_key: :item_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
