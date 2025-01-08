defmodule Handan.Production.Events.ProcessCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :process_uuid, Ecto.UUID
    field :name, :string
    field :description, :string
  end
end
