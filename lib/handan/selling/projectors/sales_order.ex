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
    DeliveryNoteCreated,
    DeliveryNoteItemAdded,
    SalesOrderConfirmed,
    SalesOrderStatusChanged,
    DeliveryNoteConfirmed
  }

  alias Handan.Selling.Projections.{SalesOrder, SalesOrderItem, DeliveryNote, DeliveryNoteItem}

  project(
    %SalesOrderCreated{} = evt,
    _meta,
    fn multi ->
      sales_order = %SalesOrder{
        uuid: evt.sales_order_uuid,
        customer_uuid: evt.customer_uuid,
        customer_name: evt.customer_name,
        total_amount: to_decimal(evt.total_amount),
        total_qty: to_decimal(evt.total_qty),
        status: to_atom(evt.status),
        delivery_status: to_atom(evt.delivery_status),
        billing_status: to_atom(evt.billing_status),
        warehouse_uuid: evt.warehouse_uuid
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
        sales_order_uuid: evt.sales_order_uuid,
        customer_uuid: evt.customer_uuid,
        status: to_atom(evt.status),
        customer_name: evt.customer_name,
        total_amount: to_decimal(evt.total_amount)
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
        unit_price: to_decimal(evt.unit_price),
        item_name: evt.item_name
      }

    Ecto.Multi.insert(multi, :delivery_note_item_added, delivery_note_item)
  end)

  project(%SalesOrderConfirmed{} = evt, _meta, fn multi ->
    set_fields = [
      status: evt.status,
    ]

    Ecto.Multi.update_all(multi, :sales_order_confirmed, sales_order_query(evt.sales_order_uuid), set: set_fields)
  end)

  project(%SalesOrderStatusChanged{} = evt, _meta, fn multi ->
    set_fields = [
      status: evt.to_status,
      delivery_status: evt.to_delivery_status,
      billing_status: evt.to_billing_status
    ]

    Ecto.Multi.update_all(multi, :sales_order_status_changed, sales_order_query(evt.sales_order_uuid), set: set_fields)
  end)


  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp sales_order_query(uuid) do
    from(so in SalesOrder, where: so.uuid == ^uuid)
  end

  defp delivery_note_query(uuid) do
    from(dn in DeliveryNote, where: dn.uuid == ^uuid)
  end
end
