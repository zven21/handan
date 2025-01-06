defmodule Handan.Stock.Projections.StockItem do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "stock_items" do
    field :total_on_hand, :decimal

    belongs_to :item, Handan.Stock.Projections.Item, references: :uuid, foreign_key: :item_uuid
    belongs_to :warehouse, Handan.Enterprise.Projections.Warehouse, references: :uuid, foreign_key: :warehouse_uuid
    belongs_to :stock_uom, Handan.Stock.Projections.StockUOM, references: :uuid, foreign_key: :stock_uom_uuid

    timestamps(type: :utc_datetime)
  end
end
