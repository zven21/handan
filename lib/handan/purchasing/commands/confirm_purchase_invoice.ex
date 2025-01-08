defmodule Handan.Purchasing.Commands.ConfirmPurchaseInvoice do
  @required_fields ~w(purchase_invoice_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :purchase_order_uuid, Ecto.UUID
    field :purchase_invoice_uuid, Ecto.UUID
  end
end
