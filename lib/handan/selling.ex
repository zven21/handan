defmodule Handan.Selling do
  @moduledoc """
  The Selling context.
  """

  alias Handan.Selling.Queries.{CustomerQuery, SalesOrderQuery, SalesInvoiceQuery}

  # customer
  defdelegate get_customer(customer_uuid), to: CustomerQuery
  defdelegate list_customers, to: CustomerQuery

  # sales order
  defdelegate get_sales_order(sales_order_uuid), to: SalesOrderQuery
  defdelegate list_sales_orders, to: SalesOrderQuery

  # sales order item
  defdelegate get_sales_order_item(sales_order_item_uuid), to: SalesOrderQuery

  # delivery note
  defdelegate get_delivery_note(delivery_note_uuid), to: SalesOrderQuery
  defdelegate list_delivery_notes, to: SalesOrderQuery

  # sales invoice
  defdelegate get_sales_invoice(sales_invoice_uuid), to: SalesInvoiceQuery
  defdelegate list_sales_invoices, to: SalesInvoiceQuery
  defdelegate unpaid_sales_invoices_by_customer(customer_uuid), to: SalesInvoiceQuery
end
