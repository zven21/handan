defmodule Handan.Purchasing do
  @moduledoc """
  The Purchasing context.
  """

  alias Handan.Turbo
  alias Handan.Purchasing.Projections.Supplier

  @doc """
  Get supplier by id
  """
  def get_supplier(supplier_id), do: Turbo.get(Supplier, supplier_id)
end
