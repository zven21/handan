defmodule Handan.Production.Events.WorkOrderItemAdded do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :work_order_item_uuid, Ecto.UUID
    field :work_order_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :item_name, :string
    field :process_uuid, Ecto.UUID
    field :process_name, :string
    field :position, :integer
    field :required_qty, :decimal
  end
end
