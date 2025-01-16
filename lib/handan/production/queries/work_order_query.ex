defmodule Handan.Production.Queries.WorkOrderQuery do
  @moduledoc false

  import Ecto.Query
  alias Handan.Turbo
  alias Handan.Production.Projections.{WorkOrder, WorkOrderItem}

  @doc """
  Get work order by uuid
  """
  def get_work_order(work_order_uuid), do: Turbo.get(WorkOrder, work_order_uuid)

  @doc """
  List work orders
  """
  def list_work_orders, do: Turbo.list(WorkOrder)

  @doc """
  Get work order item by uuid
  """
  def get_work_order_item(work_order_item_uuid), do: Turbo.get(WorkOrderItem, work_order_item_uuid)

  @doc """
  List work order items
  """
  def list_work_order_items do
    from(woi in WorkOrderItem,
      join: wo in WorkOrder,
      on: woi.work_order_uuid == wo.uuid,
      where: wo.status == :scheduling,
      select: woi
    )
    |> Turbo.list()
  end
end
