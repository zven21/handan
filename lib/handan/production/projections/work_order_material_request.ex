defmodule Handan.Production.Projections.WorkOrderMaterialRequest do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "work_order_material_requests" do
    field :item_name, :string
    field :actual_qty, :decimal
    field :remaining_qty, :decimal
    field :received_qty, :decimal

    field :uom_name, :string

    belongs_to :bom, Handan.Production.Projections.BOM, foreign_key: :bom_uuid, references: :uuid
    belongs_to :work_order, Handan.Production.Projections.WorkOrder, foreign_key: :work_order_uuid, references: :uuid
    belongs_to :item, Handan.Stock.Projections.Item, foreign_key: :item_uuid, references: :uuid
    belongs_to :stock_uom, Handan.Stock.Projections.StockUOM, foreign_key: :stock_uom_uuid, references: :uuid
    belongs_to :warehouse, Handan.Enterprise.Projections.Warehouse, foreign_key: :warehouse_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
