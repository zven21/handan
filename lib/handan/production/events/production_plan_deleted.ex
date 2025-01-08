defmodule Handan.Production.Events.ProductionPlanDeleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :production_plan_uuid, Ecto.UUID
  end
end
