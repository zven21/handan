defmodule Handan.Purchasing.Commands.ConfirmPurchaseOrder do
  @required_fields ~w(purchase_order_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :purchase_order_uuid, Ecto.UUID
  end
end
