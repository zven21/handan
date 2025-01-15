defmodule Handan.Selling.Events.SalesInvoiceCreated do
  @moduledoc false

  @required_fields ~w(sales_invoice_uuid sales_order_uuid amount)a

  use Handan.EventSourcing.Event

  defevent do
    field :sales_invoice_uuid, Ecto.UUID
    field :sales_order_uuid, Ecto.UUID
    field :code, :string

    field :customer_uuid, Ecto.UUID
    field :customer_name, :string
    field :customer_address, :string

    field :amount, :decimal
  end
end
