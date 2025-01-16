defmodule Handan.Production.Events.WorkOrderStatusChanged do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :work_order_uuid, Ecto.UUID
    field :from_status, :string
    field :to_status, :string
  end
end
