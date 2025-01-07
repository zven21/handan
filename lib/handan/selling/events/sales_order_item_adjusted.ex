defmodule Handan.Selling.Events.SalesOrderItemAdjusted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :sales_order_item_uuid, Ecto.UUID
    field :sales_order_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID

    field :delivered_qty, :decimal
    field :remaining_qty, :decimal
  end
end
