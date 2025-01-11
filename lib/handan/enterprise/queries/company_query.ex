defmodule Handan.Enterprise.Queries.CompanyQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Enterprise.Projections.Company

  def get_company(company_uuid), do: Turbo.get(Company, company_uuid)
end
