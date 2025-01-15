defmodule Handan.Enterprise do
  @moduledoc """
  The Enterprise context.
  """

  alias Handan.Enterprise.Queries.{StaffQuery, CompanyQuery}

  # staff
  defdelegate get_staff(uuid), to: StaffQuery
  defdelegate list_staff, to: StaffQuery
  defdelegate get_staff(user_uuid, company_uuid), to: StaffQuery

  # company
  defdelegate get_company(uuid), to: CompanyQuery

  # warehouse
  defdelegate list_warehouses, to: CompanyQuery
  defdelegate get_warehouse(uuid), to: CompanyQuery

  # uom
  defdelegate list_uoms, to: CompanyQuery
end
