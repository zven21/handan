defmodule HandanWeb.GraphQL.Resolvers.Purchasing do
  @moduledoc false

  alias Handan.Purchasing

  @doc "get supplier"
  def get_supplier(%{request: %{uuid: uuid}}, _) do
    {:ok, Purchasing.get_supplier(uuid)}
  end

  @doc "list suppliers"
  def get_suppliers(_, _) do
    {:ok, Purchasing.list_suppliers()}
  end

  @doc "get purchase order item"
  def get_purchase_order_item(%{request: %{uuid: uuid}}, _) do
    {:ok, Purchasing.get_purchase_order_item(uuid)}
  end
end
