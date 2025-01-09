defmodule Handan.Production.Aggregates.WorkOrder do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :work_order_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :stock_uom_uuid, Ecto.UUID
    field :warehouse_uuid, Ecto.UUID

    field :planned_qty, :decimal
    field :stored_qty, :decimal, default: 0
    field :produced_qty, :decimal, default: 0
    field :scraped_qty, :decimal, default: 0

    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :type, :string
    field :status, :string

    field :items, :map, default: %{}
    field :material_request_items, :map, default: %{}

    field :deleted?, :boolean, default: false
  end

  alias Handan.Production.Commands.{
    CreateWorkOrder,
    DeleteWorkOrder
  }

  alias Handan.Production.Events.{
    WorkOrderCreated,
    WorkOrderDeleted,
    WorkOrderItemAdded,
    MaterialRequestItemAdded
  }

  def after_event(%WorkOrderDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  def execute(%__MODULE__{work_order_uuid: nil}, %CreateWorkOrder{} = cmd) do
    work_order_evt = %WorkOrderCreated{
      work_order_uuid: cmd.work_order_uuid,
      item_uuid: cmd.item_uuid,
      stock_uom_uuid: cmd.stock_uom_uuid,
      warehouse_uuid: cmd.warehouse_uuid,
      planned_qty: cmd.planned_qty,
      start_time: cmd.start_time,
      end_time: cmd.end_time,
      type: cmd.type,
      status: :draft
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
          required_qty: item.required_qty
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
end
