defmodule Handan.Stock.Events.InventoryUnitOutbound do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :item_uuid, Ecto.UUID
    field :warehouse_uuid, Ecto.UUID
    field :stock_uom_uuid, Ecto.UUID
    field :actual_qty, :decimal
    field :type, :string
  end
end
