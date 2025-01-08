defmodule Handan.Production.Events.BOMDeleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :bom_uuid, Ecto.UUID
  end
end
