defmodule Handan.Stock.Events.StockUOMCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :stock_uom_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :uom_uuid, Ecto.UUID
    field :uom_name, :string
    field :conversion_factor, :decimal
    field :sequence, :integer
  end
end
