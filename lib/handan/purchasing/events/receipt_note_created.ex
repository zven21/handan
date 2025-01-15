defmodule Handan.Purchasing.Events.ReceiptNoteCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :receipt_note_uuid, Ecto.UUID
    field :purchase_order_uuid, Ecto.UUID
    field :code, :string
    field :supplier_uuid, Ecto.UUID
    field :supplier_name, :string
    field :supplier_address, :string
    field :total_qty, :decimal
    field :total_amount, :decimal
    field :status, :string
    field :warehouse_uuid, Ecto.UUID
  end
end
