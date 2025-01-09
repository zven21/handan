defmodule Handan.Production.Events.JobCardReported do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :job_card_uuid, Ecto.UUID
    field :work_order_item_uuid, Ecto.UUID
    field :operator_staff_uuid, Ecto.UUID
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :produced_qty, :decimal, default: 0
    field :defective_qty, :decimal, default: 0
  end
end
