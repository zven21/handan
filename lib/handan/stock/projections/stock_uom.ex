defmodule Handan.Stock.Projections.StockUOM do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "stock_uoms" do
    field :uom_name, :string
    field :conversion_factor, :integer
    field :sequence, :integer, default: 0

    belongs_to :item, Handan.Stock.Projections.Item, references: :uuid, foreign_key: :item_uuid
    belongs_to :uom, Handan.Enterprise.Projections.UOM, references: :uuid, foreign_key: :uom_uuid

    timestamps(type: :utc_datetime)
  end
end
