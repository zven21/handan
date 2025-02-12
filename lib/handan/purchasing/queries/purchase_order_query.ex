defmodule Handan.Purchasing.Queries.PurchaseOrderQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Purchasing.Projections.{PurchaseOrder, PurchaseOrderItem, ReceiptNote}

  @doc "get purchase order"
  def get_purchase_order(purchase_order_uuid), do: Turbo.get(PurchaseOrder, purchase_order_uuid)

  @doc "list purchase orders"
  def list_purchase_orders, do: Turbo.list(PurchaseOrder)

  @doc """
  Get purchase order item by id
  """
  def get_purchase_order_item(purchase_order_item_uuid), do: Turbo.get(PurchaseOrderItem, purchase_order_item_uuid)

  @doc "get receipt note"
  def get_receipt_note(receipt_note_uuid), do: Turbo.get(ReceiptNote, receipt_note_uuid)

  @doc "list receipt notes"
  def list_receipt_notes, do: Turbo.list(ReceiptNote)
end
