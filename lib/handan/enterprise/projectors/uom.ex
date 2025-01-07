defmodule Handan.Enterprise.Projectors.UOM do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false

  alias Handan.Enterprise.Events.UOMCreated
  alias Handan.Enterprise.Projections.UOM

  project(%UOMCreated{} = evt, _meta, fn multi ->
    uom = %UOM{
      uuid: evt.uom_uuid,
      name: evt.name,
      description: evt.description
    }

    Ecto.Multi.insert(multi, :uom_created, uom)
  end)
end
