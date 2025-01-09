defmodule Handan.Purchasing.Events.PurchaseInvoicePaid do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :purchase_invoice_uuid, Ecto.UUID
    field :paid_at, :utc_datetime
  end
end
