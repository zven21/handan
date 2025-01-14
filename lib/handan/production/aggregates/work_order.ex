defmodule Handan.Production.Aggregates.WorkOrder do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  import Handan.Infrastructure.DecimalHelper, only: [decimal_add: 2, decimal_sub: 2]
  alias Decimal, as: D

  deftype do
    field :work_order_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :stock_uom_uuid, Ecto.UUID
    field :warehouse_uuid, Ecto.UUID

    field :planned_qty, :decimal, default: 0
    field :stored_qty, :decimal, default: 0
    field :produced_qty, :decimal, default: 0
    field :scraped_qty, :decimal, default: 0

    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :type, Ecto.Enum, values: ~w(sales_order subcontracting produce)a, default: :produce
    field :status, Ecto.Enum, values: ~w(draft scheduling completed cancelled)a, default: :draft

    field :title, :string
    field :supplier_uuid, Ecto.UUID
    field :supplier_name, :string
    field :sales_order_uuid, Ecto.UUID

    field :items, :map, default: %{}
    field :material_request_items, :map, default: %{}
    field :job_cards, :map, default: %{}

    field :deleted?, :boolean, default: false
  end

  alias Handan.Production.Commands.{
    CreateWorkOrder,
    DeleteWorkOrder,
    ReportJobCard,
    StoreFinishItem
  }

  alias Handan.Production.Events.{
    WorkOrderCreated,
    WorkOrderDeleted,
    WorkOrderItemAdded,
    MaterialRequestItemAdded,
    JobCardReported,
    WorkOrderQtyChanged,
    WorkOrderItemQtyChanged
  }

  alias Handan.Stock.Events.InventoryUnitInbound

  def after_event(%WorkOrderDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  def execute(%__MODULE__{work_order_uuid: nil}, %CreateWorkOrder{} = cmd) do
    work_order_evt = %WorkOrderCreated{
      work_order_uuid: cmd.work_order_uuid,
      item_uuid: cmd.item_uuid,
      item_name: cmd.item_name,
      uom_name: cmd.uom_name,
      stock_uom_uuid: cmd.stock_uom_uuid,
      warehouse_uuid: cmd.warehouse_uuid,
      planned_qty: cmd.planned_qty,
      start_time: cmd.start_time,
      end_time: cmd.end_time,
      type: cmd.type,
      status: :draft,
      title: cmd.title,
      supplier_uuid: cmd.supplier_uuid,
      supplier_name: cmd.supplier_name,
      sales_order_uuid: cmd.sales_order_uuid
    }

    items_evt =
      cmd.items
      |> Enum.map(fn item ->
        %WorkOrderItemAdded{
          work_order_item_uuid: item.work_order_item_uuid,
          work_order_uuid: cmd.work_order_uuid,
          item_uuid: item.item_uuid,
          item_name: item.item_name,
          position: item.position,
          process_uuid: item.process_uuid,
          process_name: item.process_name,
          required_qty: item.required_qty,
          produced_qty: 0,
          defective_qty: 0
        }
      end)

    material_request_items_evt =
      cmd.material_request_items
      |> Enum.map(fn item ->
        %MaterialRequestItemAdded{
          material_request_item_uuid: item.material_request_item_uuid,
          work_order_uuid: cmd.work_order_uuid,
          item_uuid: item.item_uuid,
          item_name: item.item_name,
          stock_uom_uuid: item.stock_uom_uuid,
          uom_name: item.uom_name,
          actual_qty: item.actual_qty
        }
      end)

    [work_order_evt, items_evt, material_request_items_evt] |> List.flatten()
  end

  def execute(_, %CreateWorkOrder{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{work_order_uuid: work_order_uuid} = _state, %DeleteWorkOrder{work_order_uuid: work_order_uuid} = _cmd) do
    work_order_deleted_evt = %WorkOrderDeleted{
      work_order_uuid: work_order_uuid
    }

    [work_order_deleted_evt]
  end

  def execute(_, %DeleteWorkOrder{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{work_order_uuid: work_order_uuid} = state, %ReportJobCard{work_order_uuid: work_order_uuid} = cmd) do
    if Map.has_key?(state.items, cmd.work_order_item_uuid) do
      work_order_item = Map.get(state.items, cmd.work_order_item_uuid)

      case D.gt?(decimal_add(work_order_item.produced_qty, cmd.produced_qty), work_order_item.required_qty) do
        true ->
          {:error, :not_allowed}

        false ->
          job_card_reported_evt = %JobCardReported{
            job_card_uuid: cmd.job_card_uuid,
            work_order_item_uuid: cmd.work_order_item_uuid,
            operator_staff_uuid: cmd.operator_staff_uuid,
            start_time: cmd.start_time,
            end_time: cmd.end_time,
            produced_qty: cmd.produced_qty,
            defective_qty: cmd.defective_qty
          }

          work_order_item_qty_changed_evt = %WorkOrderItemQtyChanged{
            work_order_item_uuid: cmd.work_order_item_uuid,
            produced_qty: decimal_add(work_order_item.produced_qty, cmd.produced_qty),
            defective_qty: decimal_add(work_order_item.defective_qty, cmd.defective_qty)
          }

          updated_items =
            state.items
            |> Map.update!(cmd.work_order_item_uuid, fn work_order_item ->
              work_order_item
              |> Map.merge(Map.from_struct(work_order_item_qty_changed_evt))
            end)

          min_produced_qty =
            updated_items
            |> Map.values()
            |> Enum.min_by(fn item -> item.produced_qty end)
            |> Map.get(:produced_qty)

          max_defective_qty =
            updated_items
            |> Map.values()
            |> Enum.max_by(fn item -> item.defective_qty end)
            |> Map.get(:defective_qty)

          work_order_qty_changed_evt = %WorkOrderQtyChanged{
            work_order_uuid: cmd.work_order_uuid,
            produced_qty: min_produced_qty,
            scraped_qty: max_defective_qty
          }

          [job_card_reported_evt, work_order_item_qty_changed_evt, work_order_qty_changed_evt]
          |> List.flatten()
      end
    else
      {:error, :not_allowed}
    end
  end

  def execute(_, %ReportJobCard{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{work_order_uuid: work_order_uuid} = state, %StoreFinishItem{work_order_uuid: work_order_uuid} = cmd) do
    if D.gt?(state.produced_qty, state.stored_qty) do
      finish_item_stored_evt = %InventoryUnitInbound{
        item_uuid: state.item_uuid,
        warehouse_uuid: state.warehouse_uuid,
        stock_uom_uuid: state.stock_uom_uuid,
        actual_qty: cmd.stored_qty,
        type: :finish_item
      }

      work_order_qty_changed_evt = %WorkOrderQtyChanged{
        work_order_uuid: cmd.work_order_uuid,
        produced_qty: state.produced_qty,
        stored_qty: decimal_add(state.stored_qty, cmd.stored_qty)
      }

      [finish_item_stored_evt, work_order_qty_changed_evt]
    else
      {:error, :no_enough_stock}
    end
  end

  def execute(_, %StoreFinishItem{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %WorkOrderCreated{} = evt) do
    %__MODULE__{
      state
      | work_order_uuid: evt.work_order_uuid,
        item_uuid: evt.item_uuid,
        stock_uom_uuid: evt.stock_uom_uuid,
        warehouse_uuid: evt.warehouse_uuid,
        planned_qty: evt.planned_qty,
        start_time: evt.start_time,
        end_time: evt.end_time,
        type: evt.type,
        status: evt.status
    }
  end

  def apply(%__MODULE__{} = state, %WorkOrderDeleted{}) do
    %__MODULE__{state | deleted?: true}
  end

  def apply(%__MODULE__{} = state, %WorkOrderItemAdded{} = evt) do
    updated_items = state.items |> Map.put(evt.work_order_item_uuid, evt)

    %__MODULE__{
      state
      | items: updated_items
    }
  end

  def apply(%__MODULE__{} = state, %MaterialRequestItemAdded{} = evt) do
    updated_material_request_items = state.material_request_items |> Map.put(evt.material_request_item_uuid, evt)

    %__MODULE__{
      state
      | material_request_items: updated_material_request_items
    }
  end

  def apply(%__MODULE__{} = state, %JobCardReported{} = evt) do
    updated_job_cards = state.job_cards |> Map.put(evt.job_card_uuid, evt)
    %__MODULE__{state | job_cards: updated_job_cards}
  end

  def apply(%__MODULE__{} = state, %WorkOrderItemQtyChanged{} = evt) do
    updated_items =
      state.items
      |> Map.update!(evt.work_order_item_uuid, fn work_order_item ->
        work_order_item
        |> Map.merge(Map.from_struct(evt))
      end)

    %__MODULE__{state | items: updated_items}
  end

  def apply(%__MODULE__{} = state, %WorkOrderQtyChanged{} = evt) do
    %__MODULE__{state | produced_qty: evt.produced_qty, scraped_qty: evt.scraped_qty}
  end

  def apply(%__MODULE__{} = state, %InventoryUnitInbound{} = _evt) do
    state
  end
end
