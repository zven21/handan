defmodule Handan.Purchasing.Commands.CreatePurchaseInvoice do
  @moduledoc false

  @required_fields ~w(purchase_invoice_uuid purchase_order_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :purchase_invoice_uuid, Ecto.UUID
    field :purchase_order_uuid, Ecto.UUID
    field :amount, :decimal, default: 0
  end
end
