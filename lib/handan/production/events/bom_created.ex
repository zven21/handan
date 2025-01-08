defmodule Handan.Production.Events.BOMCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :bom_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :item_name, :string
    field :name, :string
  end
end
