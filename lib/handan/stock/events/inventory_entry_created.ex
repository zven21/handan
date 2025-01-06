defmodule Handan.Stock.Events.InventoryEntryCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :inventory_entry_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :warehouse_uuid, Ecto.UUID
    field :stock_uom_uuid, Ecto.UUID
    field :actual_qty, :decimal
    field :qty_after_transaction, :decimal
    field :type, :string
  end
end
