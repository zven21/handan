defmodule Handan.Stock.Events.ItemDeleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :item_uuid, Ecto.UUID
  end
end
