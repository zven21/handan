defmodule Handan.Selling.Events.CustomerDeleted do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :customer_uuid, Ecto.UUID
  end
end
