defmodule Handan.Selling.Projectors.SalesOrder do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false
  import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1]

  alias Handan.Selling.Events.{
    SalesOrderCreated,
    SalesOrderDeleted,
    SalesOrderItemAdded
  }

  alias Handan.Selling.Projections.{SalesOrder, SalesOrderItem}

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
        status: evt.status,
        delivery_status: evt.delivery_status,
        billing_status: evt.billing_status,
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

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp sales_order_query(uuid) do
    from(so in SalesOrder, where: so.uuid == ^uuid)
  end
end
