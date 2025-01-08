defmodule Handan.Production.Events.BOMItemAdded do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :bom_item_uuid, Ecto.UUID
    field :bom_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :qty, :decimal
    field :item_name, :string
  end
end
