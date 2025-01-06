defmodule Handan.Stock.Productions.Item do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :name, :string
    field :description, :string
    field :spec, :string

    field :default_stock_uom_name, :string
    field :default_stock_uom_uuid, :string

    field :opening_stock, :decimal
    field :selling_price, :decimal

    has_many :stock_items, Handan.Stock.Productions.StockItem, foreign_key: :item_uuid
    has_many :stock_uoms, Handan.Stock.Productions.StockUOM, foreign_key: :item_uuid

    timestamps(type: :utc_datetime)
  end
end
