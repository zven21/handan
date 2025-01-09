defmodule Handan.Production.Commands.ReportJobCard do
  @moduledoc false

  @required_fields ~w(job_card_uuid work_order_item_uuid produced_qty)a

  use Handan.EventSourcing.Command

  defcommand do
    field :job_card_uuid, Ecto.UUID
    field :work_order_item_uuid, Ecto.UUID
    field :produced_qty, :decimal
    field :defective_qty, :decimal, default: 0
  end
end
