defmodule Handan.Stock.Productions.StockUOM do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "stock_uoms" do
    field :conversion_factor, :integer
    field :sequence, :integer, default: 0
    field :uom_name, :string

    belongs_to :item, Handan.Stock.Productions.Item, references: :uuid, foreign_key: :item_uuid
    belongs_to :uom, Handan.Stock.Productions.UOM, references: :uuid, foreign_key: :uom_uuid

    timestamps(type: :utc_datetime)
  end
end
