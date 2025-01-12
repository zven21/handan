defmodule Handan.Production.Queries.WorkstationQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Production.Projections.Workstation

  @doc "get workstation"
  def get_workstation(workstation_uuid), do: Turbo.get(Workstation, workstation_uuid)

  @doc "list workstations"
  def list_workstations, do: Turbo.list(Workstation)
end
