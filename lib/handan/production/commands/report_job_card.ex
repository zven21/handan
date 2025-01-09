defmodule Handan.Production.Commands.ReportJobCard do
  @moduledoc false

  @required_fields ~w(job_card_uuid work_order_item_uuid produced_qty start_time end_time)a

  use Handan.EventSourcing.Command

  defcommand do
    field :job_card_uuid, Ecto.UUID
    field :work_order_uuid, Ecto.UUID
    field :work_order_item_uuid, Ecto.UUID
    field :operator_staff_uuid, Ecto.UUID
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :produced_qty, :decimal, default: 0
    field :defective_qty, :decimal, default: 0
  end
end
