defmodule Handan.Purchasing.Commands.ConfirmReceiptNote do
  @moduledoc false

  @required_fields ~w(receipt_note_uuid purchase_order_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :receipt_note_uuid, Ecto.UUID
    field :purchase_order_uuid, Ecto.UUID
  end
end
