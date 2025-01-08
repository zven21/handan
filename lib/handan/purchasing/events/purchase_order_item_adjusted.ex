defmodule Handan.Purchasing.Events.PurchaseOrderItemAdjusted do
  @moduledoc false
  use Handan.EventSourcing.Event

  defevent do
    field :purchase_order_item_uuid, Ecto.UUID
    field :purchase_order_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID

    field :received_qty, :decimal
    field :remaining_qty, :decimal
  end
end
