defmodule Handan.Production do
  @moduledoc false

  alias Handan.Production.Queries.{ProcessQuery, BOMQuery, WorkOrderQuery, WorkstationQuery}

  # process
  defdelegate get_process(process_uuid), to: ProcessQuery
  defdelegate list_processes, to: ProcessQuery

  # bom
  defdelegate get_bom(bom_uuid), to: BOMQuery
  defdelegate list_boms, to: BOMQuery

  # work order
  defdelegate get_work_order(work_order_uuid), to: WorkOrderQuery
  defdelegate list_work_orders, to: WorkOrderQuery

  # work order item
  defdelegate get_work_order_item(work_order_item_uuid), to: WorkOrderQuery
  defdelegate list_work_order_items, to: WorkOrderQuery

  # workstation
  defdelegate get_workstation(workstation_uuid), to: WorkstationQuery
  defdelegate list_workstations, to: WorkstationQuery
end
