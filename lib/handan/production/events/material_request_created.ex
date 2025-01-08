defmodule Handan.Production.Events.MaterialRequestCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :production_plan_uuid, Ecto.UUID
    field :material_request_uuid, Ecto.UUID
  end
end
