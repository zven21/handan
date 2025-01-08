defmodule Handan.Production.Events.WorkstationCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :workstation_uuid, Ecto.UUID
    field :name, :string
    field :admin_uuid, Ecto.UUID
    field :members, {:array, :map}, default: []
  end
end
