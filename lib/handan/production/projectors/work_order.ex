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

  alias Handan.Production.Projections.{WorkOrder, WorkOrderItem, WorkOrderMaterialRequest}

  project(
    %WorkOrderCreated{} = evt,
    _meta,
    fn multi ->
      {:ok, parsed_start_time} = Timex.parse(evt.start_time, "{ISO:Extended:Z}")
      {:ok, parsed_end_time} = Timex.parse(evt.end_time, "{ISO:Extended:Z}")

      work_order = %WorkOrder{
        uuid: evt.work_order_uuid,
        item_uuid: evt.item_uuid,
        stock_uom_uuid: evt.stock_uom_uuid,
        warehouse_uuid: evt.warehouse_uuid,
        planned_qty: to_decimal(evt.planned_qty),
        stored_qty: to_decimal(0),
        produced_qty: to_decimal(0),
        scraped_qty: to_decimal(0),
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
      position: evt.position,
      required_qty: to_decimal(evt.required_qty)
    }

    Ecto.Multi.insert(multi, :work_order_item_added, work_order_item)
  end)

  project(%MaterialRequestItemAdded{} = evt, _meta, fn multi ->
    work_order_material_request = %WorkOrderMaterialRequest{
      uuid: evt.material_request_item_uuid,
      work_order_uuid: evt.work_order_uuid,
      item_uuid: evt.item_uuid,
      item_name: evt.item_name,
      actual_qty: to_decimal(evt.actual_qty),
      stock_uom_uuid: evt.stock_uom_uuid,
      uom_name: evt.uom_name
    }

    Ecto.Multi.insert(multi, :work_order_material_request_added, work_order_material_request)
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp work_order_query(uuid) do
    from(w in WorkOrder, where: w.uuid == ^uuid)
  end
end
