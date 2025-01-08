defmodule Handan.Production.Events.ProductionPlanCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :production_plan_uuid, Ecto.UUID
    field :title, :string
    field :status, :string
    field :start_date, :date
    field :end_date, :date
  end
end
