defmodule Handan.Stock.Commands.IncreaseStockItem do
  @moduledoc false

  @required_fields ~w(item_uuid warehouse_uuid stock_uom_uuid qty)a

  use Handan.EventSourcing.Command

  defcommand do
    field :item_uuid, Ecto.UUID
    field :warehouse_uuid, Ecto.UUID
    field :stock_uom_uuid, Ecto.UUID
    field :qty, :decimal
  end
end
