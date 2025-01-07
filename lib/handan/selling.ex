defmodule Handan.Selling do
  @moduledoc """
  The Selling context.
  """

  alias Handan.Turbo
  alias Handan.Selling.Projections.{Customer, SalesOrderItem}

  @doc """
  Get customer by uuid.
  """
  def get_customer(customer_uuid), do: Turbo.get(Customer, customer_uuid)

  @doc """
  Get sales order item by uuid.
  """
  def get_sales_order_item(sales_order_item_uuid), do: Turbo.get(SalesOrderItem, sales_order_item_uuid)
end
