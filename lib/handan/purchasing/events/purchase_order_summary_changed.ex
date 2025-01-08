defmodule Handan.Purchasing.Events.PurchaseOrderSummaryChanged do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :purchase_order_uuid, Ecto.UUID
    field :paid_amount, :decimal
    field :remaining_amount, :decimal
    field :received_qty, :decimal
    field :remaining_qty, :decimal
  end
end
