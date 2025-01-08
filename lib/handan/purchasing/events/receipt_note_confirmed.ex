defmodule Handan.Purchasing.Events.ReceiptNoteConfirmed do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :status, :string
    field :receipt_note_uuid, Ecto.UUID
    field :purchase_order_uuid, Ecto.UUID
  end
end
