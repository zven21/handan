defmodule Handan.Enterprise do
  @moduledoc """
  The Enterprise context.
  """

  alias Handan.Enterprise.Queries.{StaffQuery, CompanyQuery}

  defdelegate get_staff(uuid), to: StaffQuery
  defdelegate get_staff(user_uuid, company_uuid), to: StaffQuery
  defdelegate get_company(uuid), to: CompanyQuery
  defdelegate list_warehouses, to: CompanyQuery
  defdelegate list_uoms, to: CompanyQuery
end
