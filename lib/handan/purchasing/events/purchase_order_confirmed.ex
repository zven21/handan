defmodule Handan.Purchasing.Events.PurchaseOrderConfirmed do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :status, :string
    field :purchase_order_uuid, Ecto.UUID
  end
end
