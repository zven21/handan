defmodule Handan.Production.Events.WorkOrderQtyChanged do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :work_order_uuid, Ecto.UUID
    field :stored_qty, :decimal, default: 0
    field :produced_qty, :decimal, default: 0
    field :scraped_qty, :decimal, default: 0
  end
end
