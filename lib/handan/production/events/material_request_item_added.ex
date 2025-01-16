defmodule Handan.Production.Events.MaterialRequestItemAdded do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :material_request_item_uuid, Ecto.UUID
    field :work_order_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :stock_uom_uuid, Ecto.UUID
    field :actual_qty, :decimal
    field :item_name, :string
    field :uom_name, :string
    field :warehouse_uuid, Ecto.UUID
  end
end
