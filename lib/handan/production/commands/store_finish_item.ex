defmodule Handan.Production.Commands.StoreFinishItem do
  @moduledoc false

  @required_fields ~w(work_order_uuid stored_qty)a

  use Handan.EventSourcing.Command

  defcommand do
    field :work_order_uuid, Ecto.UUID
    field :stored_qty, :decimal
    field :stored_at, :utc_datetime
  end
end
