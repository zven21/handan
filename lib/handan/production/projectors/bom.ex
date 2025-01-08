defmodule Handan.Production.Projectors.BOM do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext
  import Ecto.Query, warn: false

  alias Handan.Production.Events.{
    BOMCreated,
    BOMDeleted,
    BOMItemAdded,
    BOMProcessAdded
  }

  alias Handan.Production.Projections.{BOM, BOMItem, BOMProcess}

  project(
    %BOMCreated{} = evt,
    _meta,
    fn multi ->
      bom = %BOM{
        uuid: evt.bom_uuid,
        name: evt.name,
        item_uuid: evt.item_uuid,
        item_name: evt.item_name
      }

      Ecto.Multi.insert(multi, :bom_created, bom)
    end
  )

  project(%BOMDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :bom_deleted, bom_query(evt.bom_uuid))
  end)

  project(%BOMItemAdded{} = evt, _meta, fn multi ->
    bom_item = %BOMItem{
      uuid: evt.bom_item_uuid,
      bom_uuid: evt.bom_uuid,
      item_uuid: evt.item_uuid,
      qty: evt.qty,
      item_name: evt.item_name
    }

    Ecto.Multi.insert(multi, :bom_item_added, bom_item)
  end)

  project(%BOMProcessAdded{} = evt, _meta, fn multi ->
    bom_process = %BOMProcess{
      uuid: evt.bom_process_uuid,
      bom_uuid: evt.bom_uuid,
      position: evt.position,
      process_name: evt.process_name,
      process_uuid: evt.process_uuid,
      tool_required: evt.tool_required
    }

    Ecto.Multi.insert(multi, :bom_process_added, bom_process)
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp bom_query(uuid) do
    from(b in BOM, where: b.uuid == ^uuid)
  end
end
