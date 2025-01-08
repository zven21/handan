defmodule Handan.Production do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Production.Projections.{Process, BOM}

  @doc """
  Get process by uuid
  """
  def get_process(process_uuid), do: Turbo.get(Process, process_uuid)

  @doc """
  """
  def get_bom(bom_uuid), do: Turbo.get(BOM, bom_uuid, preload: [:bom_items, :bom_processes])
end
