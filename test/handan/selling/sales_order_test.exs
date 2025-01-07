defmodule Handan.Selling.SalesOrderTest do
  @moduledoc false

  use Handan.DataCase

  alias Handan.Turbo
  alias Handan.Dispatcher
  alias Handan.Selling.Projections.SalesOrder

  describe "create sales order" do
    setup [
      :create_store,
      :create_customer,
      :create_item
    ]

    test "should succeed with valid request", %{customer: customer, item: item, warehouse: warehouse} do
      request = %{
        sales_order_uuid: Ecto.UUID.generate(),
        customer_uuid: customer.uuid,
        warehouse_uuid: warehouse.uuid,
        sales_items: [
          %{
            sales_order_item_uuid: Ecto.UUID.generate(),
            item_uuid: item.uuid,
            ordered_qty: 100,
            unit_price: 10.0
          }
        ]
      }

      assert {:ok, %SalesOrder{} = sales_order} = Dispatcher.run(request, :create_sales_order)

      assert sales_order.customer_uuid == customer.uuid
      assert sales_order.warehouse_uuid == warehouse.uuid
      assert sales_order.total_qty == Decimal.new(100)
      assert sales_order.total_amount == Decimal.new("1000.0")
    end
  end

  describe "delete sales order" do
    setup [
      :create_store,
      :create_customer,
      :create_item,
      :create_sales_order
    ]

    test "should succeed with valid request", %{sales_order: sales_order} do
      request = %{
        sales_order_uuid: sales_order.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_sales_order)
      assert {:error, :not_found} == Turbo.get(SalesOrder, sales_order.uuid)
    end
  end

  describe "create delivery note" do
    setup [
      :create_store,
      :create_customer,
      :create_item,
      :create_sales_order
    ]

    test "should succeed with valid request", %{store: store, customer: customer, sales_order: sales_order} do
      sales_order_item = hd(sales_order.items)

      request = %{
        sales_order_uuid: sales_order.uuid,
        store_uuid: store.uuid,
        customer_uuid: customer.uuid,
        delivery_note_uuid: Ecto.UUID.generate(),
        delivery_items: [
          %{
            sales_order_item_uuid: sales_order_item.uuid,
            actual_qty: 1
          }
        ]
      }

      assert {:ok, delivery_note} = Dispatcher.run(request, :create_delivery_note)

      IO.inspect(delivery_note)

      # assert delivery_note.uuid == request.delivery_note_uuid
      # assert delivery_note.sales_order_uuid == sales_order.uuid
      # assert delivery_note.customer_uuid == customer.uuid
      # assert delivery_note.status == :draft
    end
  end
end
