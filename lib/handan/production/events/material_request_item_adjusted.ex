defmodule Handan.Production.Events.MaterialRequestItemAdjusted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :material_request_item_uuid, Ecto.UUID
    field :actual_qty, :decimal
    field :remaining_qty, :decimal
    field :received_qty, :decimal
  end
end
