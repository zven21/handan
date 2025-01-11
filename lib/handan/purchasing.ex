defmodule Handan.Purchasing do
  @moduledoc """
  The Purchasing context.
  """
  alias Handan.Purchasing.Queries.{SupplierQuery, PurchaseOrderQuery}

  defdelegate get_supplier(supplier_id), to: SupplierQuery
  defdelegate list_suppliers, to: SupplierQuery
  defdelegate get_purchase_order(purchase_order_uuid), to: PurchaseOrderQuery
  defdelegate get_purchase_order_item(purchase_order_item_uuid), to: PurchaseOrderQuery
  defdelegate get_purchase_invoice(purchase_invoice_uuid), to: PurchaseOrderQuery
  defdelegate list_purchase_orders, to: PurchaseOrderQuery
end
