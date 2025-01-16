defmodule Handan.Production.Commands.ScheduleWorkOrder do
  @moduledoc false

  @required_fields ~w(work_order_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :work_order_uuid, Ecto.UUID
  end
end
