defmodule Handan.Stock.Events.ItemDeleted do
  @moduledoc false

  @required_fields ~w(item_uuid)a

  use Handan.EventSourcing.Event

  defevent do
    field :item_uuid, Ecto.UUID
  end
end
