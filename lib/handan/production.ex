defmodule Handan.Production do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Production.Projections.{Process, BOM, WorkOrder}

  @doc """
  Get process by uuid
  """
  def get_process(process_uuid), do: Turbo.get(Process, process_uuid)

  @doc """
  Get bom by uuid
  """
  def get_bom(bom_uuid), do: Turbo.get(BOM, bom_uuid, preload: [:bom_items, :bom_processes])

  @doc """
  Get work order by uuid
  """
  def get_work_order(work_order_uuid), do: Turbo.get(WorkOrder, work_order_uuid, preload: [:items])
end
