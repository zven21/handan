defmodule Handan.Selling do
  @moduledoc """
  The Selling context.
  """

  alias Handan.Turbo
  alias Handan.Selling.Projections.{Customer, SalesOrderItem, SalesInvoice}

  @doc """
  Get customer by uuid.
  """
  def get_customer(customer_uuid), do: Turbo.get(Customer, customer_uuid)

  @doc """
  Get sales order item by uuid.
  """
  def get_sales_order_item(sales_order_item_uuid), do: Turbo.get(SalesOrderItem, sales_order_item_uuid)

  @doc """
  Get sales invoice by uuid.
  """
  def get_sales_invoice(sales_invoice_uuid), do: Turbo.get(SalesInvoice, sales_invoice_uuid)
end
