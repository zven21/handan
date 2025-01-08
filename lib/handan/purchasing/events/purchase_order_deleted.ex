defmodule Handan.Purchasing.Events.PurchaseOrderDeleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :purchase_order_uuid, Ecto.UUID
  end
end
