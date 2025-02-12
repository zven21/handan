defmodule Handan.Purchasing.Projectors.PurchaseOrder do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false
  import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1]
  import Handan.Infrastructure.Helper, only: [to_atom: 1]

  alias Handan.Purchasing.Events.{
    PurchaseOrderCreated,
    PurchaseOrderDeleted,
    PurchaseOrderItemAdded,
    PurchaseOrderSummaryChanged,
    PurchaseOrderStatusChanged,
    PurchaseOrderItemAdjusted
  }

  alias Handan.Purchasing.Events.{
    ReceiptNoteCreated,
    ReceiptNoteItemAdded,
    ReceiptNoteCompleted
  }

  alias Handan.Purchasing.Events.{
    PurchaseInvoiceCreated,
    PurchaseInvoicePaid
  }

  alias Handan.Purchasing.Projections.{PurchaseOrder, PurchaseOrderItem, ReceiptNote, ReceiptNoteItem, PurchaseInvoice}

  project(
    %PurchaseOrderCreated{} = evt,
    _meta,
    fn multi ->
      purchase_order = %PurchaseOrder{
        uuid: evt.purchase_order_uuid,
        code: evt.code,
        supplier_uuid: evt.supplier_uuid,
        supplier_name: evt.supplier_name,
        supplier_address: evt.supplier_address,
        warehouse_uuid: evt.warehouse_uuid,
        warehouse_name: evt.warehouse_name,
        total_amount: to_decimal(evt.total_amount),
        total_qty: to_decimal(evt.total_qty),
        status: to_atom(evt.status),
        receipt_status: to_atom(evt.receipt_status),
        billing_status: to_atom(evt.billing_status)
      }

      Ecto.Multi.insert(multi, :purchase_order_created, purchase_order)
    end
  )

  project(%PurchaseOrderDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :purchase_order_deleted, purchase_order_query(evt.purchase_order_uuid))
  end)

  project(%PurchaseOrderItemAdded{} = evt, _meta, fn multi ->
    purchase_order_item =
      %PurchaseOrderItem{
        uuid: evt.purchase_order_item_uuid,
        purchase_order_uuid: evt.purchase_order_uuid,
        item_uuid: evt.item_uuid,
        item_name: evt.item_name,
        stock_uom_uuid: evt.stock_uom_uuid,
        uom_name: evt.uom_name,
        ordered_qty: to_decimal(evt.ordered_qty),
        received_qty: to_decimal(evt.received_qty),
        remaining_qty: to_decimal(evt.remaining_qty),
        unit_price: to_decimal(evt.unit_price),
        amount: to_decimal(evt.amount)
      }

    Ecto.Multi.insert(multi, :purchase_order_item_added, purchase_order_item)
  end)

  project(%ReceiptNoteCreated{} = evt, _meta, fn multi ->
    receipt_note =
      %ReceiptNote{
        uuid: evt.receipt_note_uuid,
        purchase_order_uuid: evt.purchase_order_uuid,
        supplier_uuid: evt.supplier_uuid,
        code: evt.code,
        status: to_atom(evt.status),
        total_qty: to_decimal(evt.total_qty),
        total_amount: to_decimal(evt.total_amount),
        warehouse_uuid: evt.warehouse_uuid,
        supplier_name: evt.supplier_name
      }

    Ecto.Multi.insert(multi, :receipt_note_created, receipt_note)
  end)

  project(%ReceiptNoteItemAdded{} = evt, _meta, fn multi ->
    receipt_note_item =
      %ReceiptNoteItem{
        uuid: evt.receipt_note_item_uuid,
        receipt_note_uuid: evt.receipt_note_uuid,
        purchase_order_item_uuid: evt.purchase_order_item_uuid,
        purchase_order_uuid: evt.purchase_order_uuid,
        item_uuid: evt.item_uuid,
        actual_qty: to_decimal(evt.actual_qty),
        amount: to_decimal(evt.amount),
        stock_uom_uuid: evt.stock_uom_uuid,
        uom_name: evt.uom_name,
        unit_price: to_decimal(evt.unit_price),
        item_name: evt.item_name
      }

    Ecto.Multi.insert(multi, :receipt_note_item_added, receipt_note_item)
  end)

  project(%PurchaseOrderStatusChanged{} = evt, _meta, fn multi ->
    set_fields = [
      status: evt.to_status,
      receipt_status: evt.to_receipt_status,
      billing_status: evt.to_billing_status
    ]

    Ecto.Multi.update_all(multi, :purchase_order_status_changed, purchase_order_query(evt.purchase_order_uuid), set: set_fields)
  end)

  project(%PurchaseOrderSummaryChanged{} = evt, _meta, fn multi ->
    set_fields = [
      paid_amount: evt.paid_amount,
      remaining_amount: evt.remaining_amount,
      received_qty: evt.received_qty,
      remaining_qty: evt.remaining_qty
    ]

    Ecto.Multi.update_all(multi, :purchase_order_summary_changed, purchase_order_query(evt.purchase_order_uuid), set: set_fields)
  end)

  project(%PurchaseOrderItemAdjusted{} = evt, _meta, fn multi ->
    set_fields = [
      received_qty: evt.received_qty,
      remaining_qty: evt.remaining_qty
    ]

    Ecto.Multi.update_all(multi, :purchase_order_item_adjusted, purchase_order_item_query(evt.purchase_order_item_uuid), set: set_fields)
  end)

  project(%ReceiptNoteCompleted{} = evt, _meta, fn multi ->
    set_fields = [status: evt.status]
    Ecto.Multi.update_all(multi, :receipt_note_completed, receipt_note_query(evt.receipt_note_uuid), set: set_fields)
  end)

  project(%PurchaseInvoiceCreated{} = evt, _meta, fn multi ->
    purchase_invoice =
      %PurchaseInvoice{
        uuid: evt.purchase_invoice_uuid,
        purchase_order_uuid: evt.purchase_order_uuid,
        supplier_uuid: evt.supplier_uuid,
        supplier_name: evt.supplier_name,
        amount: to_decimal(evt.amount),
        status: to_atom(evt.status),
        code: evt.code
      }

    Ecto.Multi.insert(multi, :purchase_invoice_created, purchase_invoice)
  end)

  project(%PurchaseInvoicePaid{} = evt, _meta, fn multi ->
    set_fields = [status: :paid]
    Ecto.Multi.update_all(multi, :purchase_invoice_paid, purchase_invoice_query(evt.purchase_invoice_uuid), set: set_fields)
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp purchase_order_query(uuid) do
    from(po in PurchaseOrder, where: po.uuid == ^uuid)
  end

  defp purchase_order_item_query(uuid) do
    from(poi in PurchaseOrderItem, where: poi.uuid == ^uuid)
  end

  defp receipt_note_query(uuid) do
    from(rn in ReceiptNote, where: rn.uuid == ^uuid)
  end

  defp purchase_invoice_query(uuid) do
    from(pi in PurchaseInvoice, where: pi.uuid == ^uuid)
  end
end
