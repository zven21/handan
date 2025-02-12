defmodule Handan.Production.Events.WorkOrderCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :work_order_uuid, Ecto.UUID
    field :code, :string
    field :item_uuid, Ecto.UUID
    field :item_name, :string
    field :uom_name, :string
    field :stock_uom_uuid, Ecto.UUID
    field :warehouse_uuid, Ecto.UUID
    field :planned_qty, :decimal
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :type, :string
    field :status, :string

    field :title, :string
    field :supplier_uuid, Ecto.UUID
    field :supplier_name, :string
    field :sales_order_uuid, Ecto.UUID
  end
end
