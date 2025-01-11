defmodule Handan.Selling.Queries.SalesOrderQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Selling.Projections.{SalesOrder, SalesOrderItem, SalesInvoice, DeliveryNote}

  @doc "get sales order"
  def get_sales_order(uuid), do: Turbo.get(SalesOrder, uuid)

  @doc "list sales orders"
  def list_sales_orders, do: Turbo.list(SalesOrder)

  @doc "get sales order item"
  def get_sales_order_item(sales_order_item_uuid), do: Turbo.get(SalesOrderItem, sales_order_item_uuid)

  @doc "get sales invoice"
  def get_sales_invoice(sales_invoice_uuid), do: Turbo.get(SalesInvoice, sales_invoice_uuid)

  @doc "list sales invoices"
  def list_sales_invoices, do: Turbo.list(SalesInvoice)
end
