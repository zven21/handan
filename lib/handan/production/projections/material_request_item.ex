defmodule Handan.Production.Projections.MaterialRequestItem do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "material_request_items" do
    # TODO
    # field :stock_qty, :decimal
    # field :remaining_qty, :decimal
    # field :received_qty, :decimal

    field :actual_qty, :decimal
    field :item_name, :string
    field :uom_name, :string

    belongs_to :material_request, Handan.Production.Projections.MaterialRequest, foreign_key: :material_request_uuid, references: :uuid
    belongs_to :bom, Handan.Production.Projections.BOM, foreign_key: :bom_uuid, references: :uuid
    belongs_to :item, Handan.Stock.Projections.Item, foreign_key: :item_uuid, references: :uuid
    belongs_to :stock_uom, Handan.Stock.Projections.StockUOM, foreign_key: :stock_uom_uuid, references: :uuid
    belongs_to :from_warehouse, Handan.Enterprise.Projections.Warehouse, foreign_key: :from_warehouse_uuid, references: :uuid
    belongs_to :to_warehouse, Handan.Enterprise.Projections.Warehouse, foreign_key: :to_warehouse_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
