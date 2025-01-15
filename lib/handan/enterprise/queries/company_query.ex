defmodule Handan.Enterprise.Queries.CompanyQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Enterprise.Projections.{Company, Warehouse, UOM}

  def get_company(company_uuid), do: Turbo.get(Company, company_uuid)

  @doc "list warehouses"
  def list_warehouses, do: Turbo.list(Warehouse)

  @doc "get warehouse"
  def get_warehouse(warehouse_uuid), do: Turbo.get(Warehouse, warehouse_uuid)

  @doc "list uoms"
  def list_uoms, do: Turbo.list(UOM)
end
