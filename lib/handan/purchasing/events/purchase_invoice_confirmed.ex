defmodule Handan.Purchasing.Events.PurchaseInvoiceConfirmed do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :purchase_invoice_uuid, Ecto.UUID
    field :purchase_order_uuid, Ecto.UUID
    field :status, :string
  end
end
