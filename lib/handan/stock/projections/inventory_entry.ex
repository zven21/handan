defmodule Handan.Stock.Productions.InventoryEntry do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "inventory_entries" do
    field :actual_qty, :decimal
    field :type, :string
    field :qty_after_transaction, :decimal

    field :thread_uuid, :binary_id
    field :thread_type, :string

    belongs_to :item, Handan.Stock.Productions.Item, references: :uuid, foreign_key: :item_uuid
    belongs_to :warehouse, Handan.Stock.Productions.Warehouse, references: :uuid, foreign_key: :warehouse_uuid
    belongs_to :stock_uom, Handan.Stock.Productions.StockUOM, references: :uuid, foreign_key: :stock_uom_uuid

    timestamps(type: :utc_datetime)
  end
end
