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

    test "should succeed with valid request", %{customer: customer, item: item, stock_uom: stock_uom, warehouse: warehouse} do
      request = %{
        sales_order_uuid: Ecto.UUID.generate(),
        customer_uuid: customer.uuid,
        warehouse_uuid: warehouse.uuid,
        sales_items: [
          %{
            sales_order_item_uuid: Ecto.UUID.generate(),
            item_uuid: item.uuid,
            ordered_qty: 100,
            unit_price: 10.0,
            stock_uom_uuid: stock_uom.uuid,
            uom_name: stock_uom.uom_name
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

  describe "confirm sales order" do
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

      assert {:ok, sales_order} = Dispatcher.run(request, :confirm_sales_order)
      assert sales_order.status == :to_deliver_and_bill
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

      assert delivery_note.uuid == request.delivery_note_uuid
      assert delivery_note.sales_order_uuid == sales_order.uuid
      assert delivery_note.customer_uuid == customer.uuid
      assert delivery_note.status == :draft
    end
  end

  describe "confirm delivery note" do
    setup [
      :create_store,
      :create_customer,
      :create_item,
      :create_sales_order,
      :create_delivery_note
    ]

    test "should succeed with valid request", %{sales_order: sales_order, delivery_note: delivery_note} do
      request = %{
        sales_order_uuid: sales_order.uuid,
        delivery_note_uuid: delivery_note.uuid
      }

      assert {:ok, updated_delivery_note} = Dispatcher.run(request, :confirm_delivery_note)
      {:ok, updated_sales_order} = Turbo.get(SalesOrder, sales_order.uuid)

      assert updated_delivery_note.uuid == request.delivery_note_uuid
      assert updated_delivery_note.sales_order_uuid == sales_order.uuid
      assert updated_delivery_note.customer_uuid == sales_order.customer_uuid
      assert updated_delivery_note.status == :to_deliver

      assert updated_sales_order.status == :to_deliver_and_bill
      assert updated_sales_order.delivery_status == :partly_delivered
      assert updated_sales_order.billing_status == :not_billed
    end
  end

  describe "confirm fully delivery note" do
    setup [
      :create_store,
      :create_customer,
      :create_item,
      :create_sales_order,
      :create_fully_delivery_note
    ]

    test "should succeed with valid request", %{customer: customer, sales_order: sales_order, fully_delivery_note: fully_delivery_note} do
      request = %{
        sales_order_uuid: sales_order.uuid,
        delivery_note_uuid: fully_delivery_note.uuid
      }

      assert {:ok, updated_delivery_note} = Dispatcher.run(request, :confirm_delivery_note)
      {:ok, updated_sales_order} = Turbo.get(SalesOrder, sales_order.uuid)

      assert updated_delivery_note.uuid == request.delivery_note_uuid
      assert updated_delivery_note.sales_order_uuid == sales_order.uuid
      assert updated_delivery_note.customer_uuid == customer.uuid
      assert updated_delivery_note.status == :to_deliver

      assert updated_sales_order.status == :to_bill
      assert updated_sales_order.delivery_status == :fully_delivered
      assert updated_sales_order.billing_status == :not_billed
    end
  end

  describe "complete delivery note" do
    setup [
      :create_store,
      :create_customer,
      :create_item,
      :create_sales_order,
      :create_fully_delivery_note,
      :confirm_delivery_note
    ]

    test "should succeed with valid request", %{sales_order: sales_order, fully_delivery_note: fully_delivery_note} do
      request = %{
        sales_order_uuid: sales_order.uuid,
        delivery_note_uuid: fully_delivery_note.uuid
      }

      assert {:ok, updated_delivery_note} = Dispatcher.run(request, :complete_delivery_note)
      # TODO: 需要验证库存是否减少
      assert updated_delivery_note.status == :completed
    end
  end

  describe "create sales invoice" do
    setup [
      :create_store,
      :create_customer,
      :create_item,
      :create_sales_order
    ]

    test "should succeed with valid request", %{sales_order: sales_order} do
      request = %{
        sales_invoice_uuid: Ecto.UUID.generate(),
        sales_order_uuid: sales_order.uuid,
        amount: 1
      }

      assert {:ok, sales_invoice} = Dispatcher.run(request, :create_sales_invoice)

      assert sales_invoice.sales_order_uuid == sales_order.uuid
      assert sales_invoice.customer_uuid == sales_order.customer_uuid
      assert sales_invoice.customer_name == sales_order.customer_name
      assert sales_invoice.status == :draft
    end
  end

  describe "confirm sales invoice" do
    setup [
      :create_store,
      :create_customer,
      :create_item,
      :create_sales_order,
      :create_sales_invoice
    ]

    test "should succeed with valid request 1", %{sales_order: sales_order, sales_invoice: sales_invoice} do
      request = %{
        sales_invoice_uuid: sales_invoice.uuid,
        sales_order_uuid: sales_order.uuid
      }

      assert {:ok, sales_invoice} = Dispatcher.run(request, :confirm_sales_invoice)
      assert {:ok, updated_sales_order} = Turbo.get(SalesOrder, sales_order.uuid)

      assert sales_invoice.sales_order_uuid == sales_order.uuid
      assert sales_invoice.customer_uuid == sales_order.customer_uuid
      assert sales_invoice.customer_name == sales_order.customer_name
      assert sales_invoice.amount == Decimal.new(1)
      assert sales_invoice.status == :submitted

      assert updated_sales_order.status == :to_deliver
      assert updated_sales_order.billing_status == :partly_billed
      assert updated_sales_order.delivery_status == :not_delivered
    end
  end
end
