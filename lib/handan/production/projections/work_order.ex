defmodule Handan.Production.Projections.WorkOrder do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "work_orders" do
    field :code, :string
    field :title, :string
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    field :type, Ecto.Enum, values: ~w(sales_order subcontracting produce)a, default: :produce
    field :status, Ecto.Enum, values: ~w(draft scheduling completed cancelled)a, default: :draft

    field :planned_qty, :decimal, default: 0
    # Quantity stored
    field :stored_qty, :decimal, default: 0
    # Quantity produced
    field :produced_qty, :decimal, default: 0
    # Quantity scrapped
    field :scraped_qty, :decimal, default: 0

    field :item_name, :string
    field :stock_uom_uuid, :binary_id
    field :uom_name, :string

    field :supplier_uuid, :binary_id
    field :supplier_name, :string
    field :sales_order_uuid, :binary_id

    field :warehouse_name, :string

    belongs_to :bom, Handan.Production.Projections.BOM, foreign_key: :bom_uuid, references: :uuid
    belongs_to :warehouse, Handan.Enterprise.Projections.Warehouse, foreign_key: :warehouse_uuid, references: :uuid
    belongs_to :item, Handan.Stock.Projections.Item, foreign_key: :item_uuid, references: :uuid

    has_many :items, Handan.Production.Projections.WorkOrderItem, foreign_key: :work_order_uuid
    has_many :material_requests, Handan.Production.Projections.WorkOrderMaterialRequest, foreign_key: :work_order_uuid

    timestamps(type: :utc_datetime)
  end
end
