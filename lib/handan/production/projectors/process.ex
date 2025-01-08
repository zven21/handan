defmodule Handan.Production.Projectors.Process do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false

  alias Handan.Production.Events.{
    ProcessCreated,
    ProcessDeleted
  }

  alias Handan.Production.Projections.Process

  project(
    %ProcessCreated{} = evt,
    _meta,
    fn multi ->
      process = %Process{
        uuid: evt.process_uuid,
        name: evt.name,
        description: evt.description
      }

      Ecto.Multi.insert(multi, :process_created, process)
    end
  )

  project(%ProcessDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :process_deleted, process_query(evt.process_uuid))
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp process_query(uuid) do
    from(p in Process, where: p.uuid == ^uuid)
  end
end
