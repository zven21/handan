defmodule Handan.Purchasing do
  @moduledoc """
  The Purchasing context.
  """
  alias Handan.Purchasing.Queries.{SupplierQuery, PurchaseOrderQuery, PurchaseInvoiceQuery}

  # supplier
  defdelegate get_supplier(supplier_id), to: SupplierQuery
  defdelegate list_suppliers, to: SupplierQuery

  # purchase order
  defdelegate get_purchase_order(purchase_order_uuid), to: PurchaseOrderQuery
  defdelegate list_purchase_orders, to: PurchaseOrderQuery

  # purchase order item
  defdelegate get_purchase_order_item(purchase_order_item_uuid), to: PurchaseOrderQuery

  # receipt note
  defdelegate get_receipt_note(receipt_note_uuid), to: PurchaseOrderQuery
  defdelegate list_receipt_notes, to: PurchaseOrderQuery

  # purchase invoice
  defdelegate get_purchase_invoice(purchase_invoice_uuid), to: PurchaseInvoiceQuery
  defdelegate list_purchase_invoices, to: PurchaseInvoiceQuery
  defdelegate unpaid_purchase_invoices_by_supplier(supplier_uuid), to: PurchaseInvoiceQuery
end
