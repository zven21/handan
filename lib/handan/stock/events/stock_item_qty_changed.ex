defmodule Handan.Stock.Events.StockItemQtyChanged do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :stock_item_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :warehouse_uuid, Ecto.UUID
    field :stock_uom_uuid, Ecto.UUID
    field :total_on_hand, :decimal
  end
end
