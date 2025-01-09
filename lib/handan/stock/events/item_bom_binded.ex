defmodule Handan.Stock.Events.ItemBOMBinded do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :item_uuid, Ecto.UUID
    field :default_bom_uuid, Ecto.UUID
  end
end
