defmodule Handan.Selling.Events.SalesInvoicePaid do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :sales_invoice_uuid, Ecto.UUID
    field :paid_at, :utc_datetime
  end
end
