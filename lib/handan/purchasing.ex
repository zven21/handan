defmodule Handan.Purchasing do
  @moduledoc """
  The Purchasing context.
  """

  alias Handan.Turbo
  alias Handan.Purchasing.Projections.{Supplier, PurchaseOrderItem, PurchaseInvoice}

  @doc """
  Get supplier by id
  """
  def get_supplier(supplier_id), do: Turbo.get(Supplier, supplier_id)

  @doc """
  Get purchase order item by id
  """
  def get_purchase_order_item(purchase_order_item_uuid), do: Turbo.get(PurchaseOrderItem, purchase_order_item_uuid)

  @doc """
  Get purchase invoice by id
  """
  def get_purchase_invoice(purchase_invoice_uuid), do: Turbo.get(PurchaseInvoice, purchase_invoice_uuid)
end
