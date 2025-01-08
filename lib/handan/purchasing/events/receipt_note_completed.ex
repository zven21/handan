defmodule Handan.Purchasing.Events.ReceiptNoteCompleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :receipt_note_uuid, Ecto.UUID
    field :purchase_order_uuid, Ecto.UUID
    field :status, :string
  end
end
