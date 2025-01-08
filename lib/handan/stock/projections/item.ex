defmodule Handan.Stock.Projections.Item do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :name, :string
    field :description, :string
    field :spec, :string
    field :selling_price, :decimal

    field :default_stock_uom_name, :string
    field :default_stock_uom_uuid, :binary_id

    belongs_to :bom, Handan.Production.Projections.BOM, foreign_key: :default_bom_uuid, references: :uuid

    has_many :stock_items, Handan.Stock.Projections.StockItem, foreign_key: :item_uuid
    has_many :stock_uoms, Handan.Stock.Projections.StockUOM, foreign_key: :item_uuid
    has_many :inventory_entries, Handan.Stock.Projections.InventoryEntry, foreign_key: :item_uuid

    timestamps(type: :utc_datetime)
  end
end
