defmodule Handan.Stock.Events.ItemCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :item_uuid, Ecto.UUID
    field :name, :string
    field :description, :string
    field :selling_price, :decimal
    field :default_stock_uom_uuid, Ecto.UUID
    field :default_stock_uom_name, :string
  end
end
