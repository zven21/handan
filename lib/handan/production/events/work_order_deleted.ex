defmodule Handan.Production.Events.WorkOrderDeleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :work_order_uuid, Ecto.UUID
  end
end
