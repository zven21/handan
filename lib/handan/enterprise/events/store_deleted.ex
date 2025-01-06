defmodule Handan.Enterprise.Events.StoreDeleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :store_uuid, Ecto.UUID
  end
end
