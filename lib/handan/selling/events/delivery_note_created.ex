defmodule Handan.Selling.Events.DeliveryNoteCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :delivery_note_uuid, Ecto.UUID
    field :sales_order_uuid, Ecto.UUID
    field :customer_uuid, Ecto.UUID
    field :status, :string
    field :customer_name, :string
    field :customer_address, :string
    field :total_qty, :decimal
    field :total_amount, :decimal
  end
end
