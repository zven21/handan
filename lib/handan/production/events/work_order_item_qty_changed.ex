defmodule Handan.Production.Events.WorkOrderItemQtyChanged do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :work_order_item_uuid, Ecto.UUID
    field :produced_qty, :decimal, default: 0
    field :defective_qty, :decimal, default: 0
  end
end
