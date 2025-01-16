defmodule Handan.Selling.Queries.SalesInvoiceQuery do
  @moduledoc false

  import Ecto.Query
  alias Handan.Turbo
  alias Handan.Selling.Projections.{SalesInvoice}

  @doc "get sales invoice"
  def get_sales_invoice(sales_invoice_uuid), do: Turbo.get(SalesInvoice, sales_invoice_uuid)

  @doc "list sales invoices"
  def list_sales_invoices, do: Turbo.list(SalesInvoice)

  @doc "unpaid sales invoices by customer"
  def unpaid_sales_invoices_by_customer(customer_uuid) do
    from(s in SalesInvoice, where: s.customer_uuid == ^customer_uuid, where: s.status == :submitted)
    |> Turbo.list()
  end
end
