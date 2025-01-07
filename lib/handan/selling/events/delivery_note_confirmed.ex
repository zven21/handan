defmodule Handan.Selling.Events.DeliveryNoteConfirmed do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :status, :string
    field :delivery_note_uuid, Ecto.UUID
    field :sales_order_uuid, Ecto.UUID
  end
end
