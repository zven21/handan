defmodule Handan.Selling.Events.SalesOrderSummaryChanged do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :sales_order_uuid, Ecto.UUID
    field :paid_amount, :decimal
    field :remaining_amount, :decimal
    field :delivered_qty, :decimal
    field :remaining_qty, :decimal
  end
end
