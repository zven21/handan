defmodule Handan.Production.Events.ProcessDeleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :process_uuid, Ecto.UUID
  end
end
