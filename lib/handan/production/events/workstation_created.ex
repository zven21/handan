defmodule Handan.Production.Events.WorkstationCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :workstation_uuid, Ecto.UUID
    field :name, :string
  end
end
