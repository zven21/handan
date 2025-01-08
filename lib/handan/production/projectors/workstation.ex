defmodule Handan.Production.Projectors.Workstation do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext
  import Ecto.Query, warn: false

  alias Handan.Production.Events.{
    WorkstationCreated,
    WorkstationDeleted
  }

  alias Handan.Production.Projections.Workstation

  project(
    %WorkstationCreated{} = evt,
    _meta,
    fn multi ->
      workstation = %Workstation{
        uuid: evt.workstation_uuid,
        name: evt.name,
        admin_uuid: evt.admin_uuid,
        members: evt.members
      }

      Ecto.Multi.insert(multi, :workstation_created, workstation)
    end
  )

  project(%WorkstationDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :workstation_deleted, workstation_query(evt.workstation_uuid))
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp workstation_query(uuid) do
    from(w in Workstation, where: w.uuid == ^uuid)
  end
end
