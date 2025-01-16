defmodule HandanWeb.GraphQL.Resolvers.Enterprise do
  @moduledoc false

  alias Handan.Enterprise
  alias Handan.Dispatcher

  @doc "get company"
  def get_company(_, %{context: %{current_company: company}}), do: Enterprise.get_company(company.uuid)

  @doc "list staff"
  def list_staff(_, _), do: Enterprise.list_staff()

  @doc "create company"
  def create_company(_, %{request: request}, %{context: %{current_user: user}}) do
    request
    |> Map.put(:user_uuid, user.uuid)
    |> Map.put(:company_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_company)
  end

  @doc "list warehouses"
  def list_warehouses(_, _), do: Enterprise.list_warehouses()

  @doc "list uoms"
  def list_uoms(_, _), do: Enterprise.list_uoms()
end
