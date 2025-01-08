defmodule Handan.Purchasing.Events.ReceiptNoteItemAdded do
  @moduledoc false
  use Handan.EventSourcing.Event

  defevent do
    field :receipt_note_item_uuid, Ecto.UUID
    field :receipt_note_uuid, Ecto.UUID
    field :purchase_order_item_uuid, Ecto.UUID
    field :purchase_order_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID

    field :stock_uom_uuid, Ecto.UUID
    field :uom_name, :string

    field :actual_qty, :decimal
    field :amount, :decimal
    field :unit_price, :decimal
    field :item_name, :string
  end
end
