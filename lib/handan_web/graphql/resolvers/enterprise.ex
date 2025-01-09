defmodule HandanWeb.GraphQL.Resolvers.Enterprise do
  @moduledoc false

  @doc "get company"
  def get_company(_, %{context: %{current_company: company}}), do: {:ok, company}
end
