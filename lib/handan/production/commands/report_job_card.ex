defmodule Handan.Production.Commands.ReportJobCard do
  @moduledoc false

  @required_fields ~w(job_card_uuid work_order_item_uuid production_qty)a

  use Handan.EventSourcing.Command

  defcommand do
    field :job_card_uuid, Ecto.UUID
    field :work_order_item_uuid, Ecto.UUID
    field :production_qty, :integer
    field :defective_qty, :integer, default: 0
  end
end
