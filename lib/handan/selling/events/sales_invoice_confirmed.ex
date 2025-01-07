defmodule Handan.Selling.Events.SalesInvoiceConfirmed do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :sales_invoice_uuid, Ecto.UUID
    field :sales_order_uuid, Ecto.UUID
    field :status, :string
  end
end
