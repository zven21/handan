defmodule HandanWeb.GraphQL.Resolvers.Enterprise do
  @moduledoc false

  alias Handan.Enterprise
  alias Handan.Dispatcher

  @doc "get company"
  def get_company(_, %{context: %{current_company: company}}), do: {:ok, company}

  @doc "create company"
  def create_company(%{request: request}, %{context: %{current_user: user, current_company: company}}, _) do
    request
    |> Map.put(:user_uuid, user.uuid)
    |> Map.put(:company_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_company)
  end
end
