defmodule Handan.Purchasing.Events.PurchaseInvoiceCreated do
  @moduledoc false

  @required_fields ~w(purchase_invoice_uuid purchase_order_uuid amount)a

  use Handan.EventSourcing.Event

  defevent do
    field :purchase_invoice_uuid, Ecto.UUID
    field :purchase_order_uuid, Ecto.UUID

    field :supplier_uuid, Ecto.UUID
    field :supplier_name, :string
    field :supplier_address, :string

    field :amount, :decimal
  end
end
