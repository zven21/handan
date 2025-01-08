defmodule Handan.Production.Events.ProductionPlanItemAdded do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :production_plan_item_uuid, Ecto.UUID
    field :production_plan_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :item_name, :string
    field :planned_qty, :decimal
  end
end
