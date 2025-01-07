defmodule Handan.Selling.Events.DeliveryNoteCompleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :delivery_note_uuid, Ecto.UUID
    field :sales_order_uuid, Ecto.UUID
    field :status, :string
  end
end
