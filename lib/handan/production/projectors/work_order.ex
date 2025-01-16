defmodule Handan.Production.Projectors.WorkOrder do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false
  import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1]
  import Handan.Infrastructure.Helper, only: [to_atom: 1]

  alias Handan.Production.Events.{
    WorkOrderCreated,
    WorkOrderDeleted,
    WorkOrderItemAdded,
    MaterialRequestItemAdded,
    MaterialRequestItemAdjusted,
    JobCardReported,
    WorkOrderQtyChanged,
    WorkOrderStatusChanged,
    WorkOrderScheduled,
    WorkOrderItemQtyChanged
  }

  alias Handan.Production.Projections.{WorkOrder, WorkOrderItem, WorkOrderMaterialRequest, JobCard}

  project(
    %WorkOrderCreated{} = evt,
    _meta,
    fn multi ->
      {:ok, parsed_start_time} = Timex.parse(evt.start_time, "{ISO:Extended:Z}")
      {:ok, parsed_end_time} = Timex.parse(evt.end_time, "{ISO:Extended:Z}")

      work_order = %WorkOrder{
        uuid: evt.work_order_uuid,
        code: evt.code,
        item_uuid: evt.item_uuid,
        item_name: evt.item_name,
        uom_name: evt.uom_name,
        stock_uom_uuid: evt.stock_uom_uuid,
        warehouse_uuid: evt.warehouse_uuid,
        planned_qty: to_decimal(evt.planned_qty),
        stored_qty: to_decimal(0),
        produced_qty: to_decimal(0),
        scraped_qty: to_decimal(0),
        start_time: parsed_start_time,
        end_time: parsed_end_time,
        type: to_atom(evt.type),
        status: to_atom(evt.status),
        title: evt.title,
        supplier_uuid: evt.supplier_uuid,
        supplier_name: evt.supplier_name,
        sales_order_uuid: evt.sales_order_uuid
      }

      Ecto.Multi.insert(multi, :work_order_created, work_order)
    end
  )

  project(%WorkOrderDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :work_order_deleted, work_order_query(evt.work_order_uuid))
  end)

  project(%WorkOrderScheduled{} = evt, _meta, fn multi ->
    Ecto.Multi.update_all(multi, :work_order_scheduled, work_order_query(evt.work_order_uuid), set: [status: :scheduling])
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
      required_qty: to_decimal(evt.required_qty),
      produced_qty: to_decimal(evt.produced_qty),
      defective_qty: to_decimal(evt.defective_qty)
    }

    Ecto.Multi.insert(multi, :work_order_item_added, work_order_item)
  end)

  project(%MaterialRequestItemAdded{} = evt, _meta, fn multi ->
    work_order_material_request = %WorkOrderMaterialRequest{
      uuid: evt.material_request_item_uuid,
      work_order_uuid: evt.work_order_uuid,
      item_uuid: evt.item_uuid,
      item_name: evt.item_name,
      warehouse_uuid: evt.warehouse_uuid,
      actual_qty: to_decimal(evt.actual_qty),
      stock_uom_uuid: evt.stock_uom_uuid,
      uom_name: evt.uom_name
    }

    Ecto.Multi.insert(multi, :work_order_material_request_added, work_order_material_request)
  end)

  project(%MaterialRequestItemAdjusted{} = evt, _meta, fn multi ->
    set_fields = [
      received_qty: to_decimal(evt.received_qty),
      remaining_qty: to_decimal(evt.remaining_qty)
    ]

    Ecto.Multi.update_all(multi, :material_request_item_adjusted, work_order_material_request_query(evt.material_request_item_uuid), set: set_fields)
  end)

  project(%JobCardReported{} = evt, _meta, fn multi ->
    {:ok, parsed_start_time} = Timex.parse(evt.start_time, "{ISO:Extended:Z}")
    {:ok, parsed_end_time} = Timex.parse(evt.end_time, "{ISO:Extended:Z}")

    job_card = %JobCard{
      uuid: evt.job_card_uuid,
      work_order_item_uuid: evt.work_order_item_uuid,
      operator_staff_uuid: evt.operator_staff_uuid,
      start_time: parsed_start_time,
      end_time: parsed_end_time,
      produced_qty: to_decimal(evt.produced_qty),
      defective_qty: to_decimal(evt.defective_qty)
    }

    Ecto.Multi.insert(multi, :job_card_reported, job_card)
  end)

  project(%WorkOrderQtyChanged{} = evt, _meta, fn multi ->
    set_fields = [
      stored_qty: evt.stored_qty,
      produced_qty: evt.produced_qty,
      scraped_qty: evt.scraped_qty
    ]

    Ecto.Multi.update_all(multi, :work_order_qty_changed, work_order_query(evt.work_order_uuid), set: set_fields)
  end)

  project(%WorkOrderStatusChanged{} = evt, _meta, fn multi ->
    set_fields = [
      status: evt.to_status
    ]

    Ecto.Multi.update_all(multi, :work_order_status_changed, work_order_query(evt.work_order_uuid), set: set_fields)
  end)

  project(%WorkOrderItemQtyChanged{} = evt, _meta, fn multi ->
    set_fields = [
      produced_qty: evt.produced_qty,
      defective_qty: evt.defective_qty
    ]

    Ecto.Multi.update_all(multi, :work_order_item_qty_changed, work_order_item_query(evt.work_order_item_uuid), set: set_fields)
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp work_order_query(uuid) do
    from(w in WorkOrder, where: w.uuid == ^uuid)
  end

  defp work_order_item_query(uuid) do
    from(w in WorkOrderItem, where: w.uuid == ^uuid)
  end

  defp work_order_material_request_query(uuid) do
    from(w in WorkOrderMaterialRequest, where: w.uuid == ^uuid)
  end
end
