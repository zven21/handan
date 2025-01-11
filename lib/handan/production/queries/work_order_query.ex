defmodule Handan.Production.Queries.WorkOrderQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Production.Projections.WorkOrder

  @doc """
  Get work order by uuid
  """
  def get_work_order(work_order_uuid), do: Turbo.get(WorkOrder, work_order_uuid)

  @doc """
  List work orders
  """
  def list_work_orders, do: Turbo.list(WorkOrder)
end
