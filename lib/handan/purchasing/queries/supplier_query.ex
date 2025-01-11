defmodule Handan.Purchasing.Queries.SupplierQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Purchasing.Projections.Supplier

  @doc "get supplier"
  def get_supplier(uuid), do: Turbo.get(Supplier, uuid)

  @doc "list suppliers"
  def list_suppliers, do: Turbo.list(Supplier)
end
