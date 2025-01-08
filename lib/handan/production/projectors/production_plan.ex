defmodule Handan.Production.Projectors.ProductionPlan do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false
  import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1]

  alias Handan.Production.Events.{
    ProductionPlanCreated,
    ProductionPlanDeleted,
    ProductionPlanItemAdded,
    MaterialRequestCreated,
    MaterialRequestItemAdded
  }

  alias Handan.Production.Projections.{ProductionPlan, ProductionPlanItem, MaterialRequest, MaterialRequestItem}

  project(
    %ProductionPlanCreated{} = evt,
    _meta,
    fn multi ->
      {:ok, parsed_start_date} = Date.from_iso8601(evt.start_date)
      {:ok, parsed_end_date} = Date.from_iso8601(evt.end_date)

      production_plan = %ProductionPlan{
        uuid: evt.production_plan_uuid,
        title: evt.title,
        start_date: parsed_start_date,
        end_date: parsed_end_date,
        status: evt.status
      }

      Ecto.Multi.insert(multi, :production_plan_created, production_plan)
    end
  )

  project(%ProductionPlanDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :production_plan_deleted, production_plan_query(evt.production_plan_uuid))
  end)

  project(%ProductionPlanItemAdded{} = evt, _meta, fn multi ->
    production_plan_item = %ProductionPlanItem{
      uuid: evt.production_plan_item_uuid,
      production_plan_uuid: evt.production_plan_uuid,
      item_uuid: evt.item_uuid,
      item_name: evt.item_name,
      planned_qty: evt.planned_qty
    }

    Ecto.Multi.insert(multi, :production_plan_item_added, production_plan_item)
  end)

  project(%MaterialRequestCreated{} = evt, _meta, fn multi ->
    material_request = %MaterialRequest{
      uuid: evt.material_request_uuid,
      production_plan_uuid: evt.production_plan_uuid
    }

    Ecto.Multi.insert(multi, :material_request_created, material_request)
  end)

  project(%MaterialRequestItemAdded{} = evt, _meta, fn multi ->
    material_request_item = %MaterialRequestItem{
      uuid: evt.material_request_item_uuid,
      material_request_uuid: evt.material_request_uuid,
      item_uuid: evt.item_uuid,
      item_name: evt.item_name,
      actual_qty: to_decimal(evt.actual_qty),
      stock_uom_uuid: evt.stock_uom_uuid,
      uom_name: evt.uom_name
    }

    Ecto.Multi.insert(multi, :material_request_item_added, material_request_item)
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp production_plan_query(uuid) do
    from(p in ProductionPlan, where: p.uuid == ^uuid)
  end
end
