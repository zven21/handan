defmodule Handan.Enterprise.Projectors.Store do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false

  alias Handan.Enterprise.Events.{
    StoreCreated,
    StoreDeleted
  }

  alias Handan.Enterprise.Projections.Store

  project(
    %StoreCreated{} = evt,
    _meta,
    fn multi ->
      store = %Store{
        uuid: evt.store_uuid,
        name: evt.name,
        description: evt.description
      }

      Ecto.Multi.insert(multi, :store_created, store)
    end
  )

  project(%StoreDeleted{store_uuid: uuid}, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :store_deleted, store_query(uuid))
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  def store_query(uuid) do
    from(s in Store, where: s.uuid == ^uuid)
  end
end
