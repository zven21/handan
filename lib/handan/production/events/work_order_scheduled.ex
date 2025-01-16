defmodule Handan.Production.Events.WorkOrderScheduled do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :work_order_uuid, Ecto.UUID
  end
end
