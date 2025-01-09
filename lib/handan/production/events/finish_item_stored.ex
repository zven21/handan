defmodule Handan.Production.Events.FinishItemStored do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :work_order_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :stock_uom_uuid, Ecto.UUID
    field :warehouse_uuid, Ecto.UUID
    field :stored_qty, :decimal
    field :stored_at, :utc_datetime
  end
end
