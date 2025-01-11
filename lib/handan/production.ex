defmodule Handan.Production do
  @moduledoc false

  alias Handan.Production.Queries.{ProcessQuery, BOMQuery, WorkOrderQuery}

  defdelegate get_process(process_uuid), to: ProcessQuery
  defdelegate get_bom(bom_uuid), to: BOMQuery
  defdelegate get_work_order(work_order_uuid), to: WorkOrderQuery
end
