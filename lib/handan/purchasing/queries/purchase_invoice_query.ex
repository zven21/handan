defmodule Handan.Purchasing.Queries.PurchaseInvoiceQuery do
  @moduledoc false

  import Ecto.Query
  alias Handan.Turbo
  alias Handan.Purchasing.Projections.{PurchaseInvoice}

  @doc """
  Get purchase invoice by id
  """
  def get_purchase_invoice(purchase_invoice_uuid), do: Turbo.get(PurchaseInvoice, purchase_invoice_uuid)

  @doc "list purchase invoices"
  def list_purchase_invoices, do: Turbo.list(PurchaseInvoice)

  @doc "unpaid purchase invoices by supplier"
  def unpaid_purchase_invoices_by_supplier(supplier_uuid) do
    from(p in PurchaseInvoice, where: p.supplier_uuid == ^supplier_uuid, where: p.status == :unpaid)
    |> Turbo.list()
  end
end
