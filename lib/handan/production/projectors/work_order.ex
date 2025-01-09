defmodule Handan.Production.Projectors.WorkOrder do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false
  import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1]

  alias Handan.Production.Events.{
    WorkOrderCreated,
    WorkOrderDeleted,
    WorkOrderItemAdded,
    MaterialRequestItemAdded
  }

  alias Handan.Production.Projections.{WorkOrder, WorkOrderItem, MaterialRequest, MaterialRequestItem}

  project(
    %WorkOrderCreated{} = evt,
    _meta,
    fn multi ->
      {:ok, parsed_start_time} = DateTime.from_iso8601(evt.start_time)
      {:ok, parsed_end_time} = DateTime.from_iso8601(evt.end_time)

      work_order = %WorkOrder{
        uuid: evt.work_order_uuid,
        item_uuid: evt.item_uuid,
        stock_uom_uuid: evt.stock_uom_uuid,
        warehouse_uuid: evt.warehouse_uuid,
        planned_qty: evt.planned_qty,
        start_time: parsed_start_time,
        end_time: parsed_end_time,
        type: evt.type,
        status: evt.status
      }

      Ecto.Multi.insert(multi, :work_order_created, work_order)
    end
  )

  project(%WorkOrderDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :work_order_deleted, work_order_query(evt.work_order_uuid))
  end)

  project(%WorkOrderItemAdded{} = evt, _meta, fn multi ->
    work_order_item = %WorkOrderItem{
      uuid: evt.work_order_item_uuid,
      work_order_uuid: evt.work_order_uuid,
      item_uuid: evt.item_uuid,
      item_name: evt.item_name,
      process_uuid: evt.process_uuid,
      process_name: evt.process_name,
      required_qty: evt.required_qty
    }

    Ecto.Multi.insert(multi, :work_order_item_added, work_order_item)
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

  defp work_order_query(uuid) do
    from(w in WorkOrder, where: w.uuid == ^uuid)
  end
end
