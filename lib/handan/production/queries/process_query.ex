defmodule Handan.Production.Queries.ProcessQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Production.Projections.Process

  @doc """
  Get process by uuid
  """
  def get_process(process_uuid), do: Turbo.get(Process, process_uuid)

  @doc """
  List processes
  """
  def list_processes, do: Turbo.list(Process)
end
