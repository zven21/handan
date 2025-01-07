defmodule Handan.Selling.Events.SalesOrderItemAdded do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :sales_order_item_uuid, Ecto.UUID
    field :sales_order_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :amount, :decimal
    field :unit_price, :decimal
    field :item_name, :string

    field :stock_uom_uuid, Ecto.UUID
    field :uom_name, :string

    field :ordered_qty, :decimal
    field :delivered_qty, :decimal
    field :remaining_qty, :decimal
    field :warehouse_uuid, Ecto.UUID
  end
end
