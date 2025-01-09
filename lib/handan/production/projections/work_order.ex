defmodule Handan.Production.Projections.WorkOrder do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "work_orders" do
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :type, :string
    field :status, :string

    field :planned_qty, :decimal, default: 0
    # 已入库数量
    field :stored_qty, :decimal, default: 0
    # 已生产数量
    field :produced_qty, :decimal, default: 0
    # 已报废数量
    field :scraped_qty, :decimal, default: 0

    field :item_name, :string
    field :item_uuid, Ecto.UUID
    field :stock_uom_uuid, Ecto.UUID
    field :stock_uom_name, :string
    field :warehouse_uuid, Ecto.UUID
    field :bom_uuid, Ecto.UUID

    has_one :material_request, Handan.Production.Projections.MaterialRequest, foreign_key: :work_order_uuid

    has_many :items, Handan.Production.Projections.WorkOrderItem, foreign_key: :work_order_uuid

    timestamps(type: :utc_datetime)
  end
end
