defmodule Handan.Selling.Projectors.SalesOrder do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false
  import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1]
  import Handan.Infrastructure.Helper, only: [to_atom: 1]

  alias Handan.Selling.Events.{
    SalesOrderCreated,
    SalesOrderDeleted,
    SalesOrderItemAdded,
    SalesOrderStatusChanged,
    SalesOrderSummaryChanged,
    SalesOrderItemAdjusted
  }

  alias Handan.Selling.Events.{
    SalesInvoiceCreated,
    SalesInvoicePaid
  }

  alias Handan.Selling.Events.{
    DeliveryNoteCreated,
    DeliveryNoteItemAdded,
    DeliveryNoteCompleted
  }

  alias Handan.Selling.Projections.{SalesOrder, SalesOrderItem, DeliveryNote, DeliveryNoteItem, SalesInvoice}

  project(
    %SalesOrderCreated{} = evt,
    _meta,
    fn multi ->
      sales_order = %SalesOrder{
        uuid: evt.sales_order_uuid,
        code: evt.code,
        customer_uuid: evt.customer_uuid,
        customer_name: evt.customer_name,
        total_amount: to_decimal(evt.total_amount),
        remaining_amount: to_decimal(evt.total_amount),
        paid_amount: to_decimal(evt.paid_amount),
        total_qty: to_decimal(evt.total_qty),
        delivered_qty: to_decimal(evt.delivered_qty),
        remaining_qty: to_decimal(evt.remaining_qty),
        status: to_atom(evt.status),
        delivery_status: to_atom(evt.delivery_status),
        billing_status: to_atom(evt.billing_status),
        warehouse_uuid: evt.warehouse_uuid,
        warehouse_name: evt.warehouse_name
      }

      Ecto.Multi.insert(multi, :sales_order_created, sales_order)
    end
  )

  project(%SalesOrderDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :sales_order_deleted, sales_order_query(evt.sales_order_uuid))
  end)

  project(%SalesOrderItemAdded{} = evt, _meta, fn multi ->
    sales_order_item =
      %SalesOrderItem{
        uuid: evt.sales_order_item_uuid,
        sales_order_uuid: evt.sales_order_uuid,
        item_uuid: evt.item_uuid,
        item_name: evt.item_name,
        stock_uom_uuid: evt.stock_uom_uuid,
        uom_name: evt.uom_name,
        ordered_qty: to_decimal(evt.ordered_qty),
        delivered_qty: to_decimal(evt.delivered_qty),
        remaining_qty: to_decimal(evt.remaining_qty),
        unit_price: to_decimal(evt.unit_price),
        amount: to_decimal(evt.amount)
      }

    Ecto.Multi.insert(multi, :sales_order_item_added, sales_order_item)
  end)

  project(%DeliveryNoteCreated{} = evt, _meta, fn multi ->
    delivery_note =
      %DeliveryNote{
        uuid: evt.delivery_note_uuid,
        code: evt.code,
        sales_order_uuid: evt.sales_order_uuid,
        customer_uuid: evt.customer_uuid,
        status: to_atom(evt.status),
        total_qty: to_decimal(evt.total_qty),
        total_amount: to_decimal(evt.total_amount),
        warehouse_uuid: evt.warehouse_uuid,
        customer_name: evt.customer_name
      }

    Ecto.Multi.insert(multi, :delivery_note_created, delivery_note)
  end)

  project(%DeliveryNoteItemAdded{} = evt, _meta, fn multi ->
    delivery_note_item =
      %DeliveryNoteItem{
        uuid: evt.delivery_note_item_uuid,
        delivery_note_uuid: evt.delivery_note_uuid,
        sales_order_item_uuid: evt.sales_order_item_uuid,
        sales_order_uuid: evt.sales_order_uuid,
        item_uuid: evt.item_uuid,
        actual_qty: to_decimal(evt.actual_qty),
        amount: to_decimal(evt.amount),
        stock_uom_uuid: evt.stock_uom_uuid,
        uom_name: evt.uom_name,
        unit_price: to_decimal(evt.unit_price),
        item_name: evt.item_name
      }

    Ecto.Multi.insert(multi, :delivery_note_item_added, delivery_note_item)
  end)

  project(%SalesOrderStatusChanged{} = evt, _meta, fn multi ->
    set_fields = [
      status: evt.to_status,
      delivery_status: evt.to_delivery_status,
      billing_status: evt.to_billing_status
    ]

    Ecto.Multi.update_all(multi, :sales_order_status_changed, sales_order_query(evt.sales_order_uuid), set: set_fields)
  end)

  project(%SalesOrderSummaryChanged{} = evt, _meta, fn multi ->
    set_fields = [
      paid_amount: evt.paid_amount,
      remaining_amount: evt.remaining_amount,
      delivered_qty: evt.delivered_qty,
      remaining_qty: evt.remaining_qty
    ]

    Ecto.Multi.update_all(multi, :sales_order_summary_changed, sales_order_query(evt.sales_order_uuid), set: set_fields)
  end)

  project(%SalesOrderItemAdjusted{} = evt, _meta, fn multi ->
    set_fields = [
      delivered_qty: evt.delivered_qty,
      remaining_qty: evt.remaining_qty
    ]

    Ecto.Multi.update_all(multi, :sales_order_item_adjusted, sales_order_item_query(evt.sales_order_item_uuid), set: set_fields)
  end)

  project(%DeliveryNoteCompleted{} = evt, _meta, fn multi ->
    set_fields = [status: evt.status]
    Ecto.Multi.update_all(multi, :delivery_note_completed, delivery_note_query(evt.delivery_note_uuid), set: set_fields)
  end)

  project(%SalesInvoiceCreated{} = evt, _meta, fn multi ->
    sales_invoice =
      %SalesInvoice{
        uuid: evt.sales_invoice_uuid,
        sales_order_uuid: evt.sales_order_uuid,
        customer_uuid: evt.customer_uuid,
        customer_name: evt.customer_name,
        amount: to_decimal(evt.amount),
        status: to_atom(evt.status),
        code: evt.code
      }

    Ecto.Multi.insert(multi, :sales_invoice_created, sales_invoice)
  end)

  project(%SalesInvoicePaid{} = evt, _meta, fn multi ->
    # set_fields = [status: :paid, paid_at: evt.paid_at]
    set_fields = [status: :paid]
    Ecto.Multi.update_all(multi, :sales_invoice_paid, sales_invoice_query(evt.sales_invoice_uuid), set: set_fields)
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp sales_order_query(uuid) do
    from(so in SalesOrder, where: so.uuid == ^uuid)
  end

  defp sales_order_item_query(uuid) do
    from(soi in SalesOrderItem, where: soi.uuid == ^uuid)
  end

  defp delivery_note_query(uuid) do
    from(dn in DeliveryNote, where: dn.uuid == ^uuid)
  end

  defp sales_invoice_query(uuid) do
    from(si in SalesInvoice, where: si.uuid == ^uuid)
  end
end
