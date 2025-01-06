defmodule Handan.Enterprise.Events.UOMCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :uom_uuid, Ecto.UUID
    field :store_uuid, Ecto.UUID
    field :name, :string
    field :description, :string
  end
end
