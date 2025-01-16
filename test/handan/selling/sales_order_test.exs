defmodule Handan.Selling.SalesOrderTest do
  @moduledoc false

  use Handan.DataCase

  import Handan.Infrastructure.DecimalHelper, only: [decimal_sub: 2]

  alias Handan.Turbo
  alias Handan.Dispatcher
  alias Handan.Selling.Projections.SalesOrder
  alias Handan.Stock.Projections.StockItem

  describe "create sales order" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item
    ]

    test "should succeed with valid request with is_draft is true", %{customer: customer, item: item, stock_uom: stock_uom, warehouse: warehouse} do
      request = %{
        sales_order_uuid: Ecto.UUID.generate(),
        customer_uuid: customer.uuid,
        warehouse_uuid: warehouse.uuid,
        is_draft: true,
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

      assert sales_order.status == :draft
      assert sales_order.customer_uuid == customer.uuid
      assert sales_order.warehouse_uuid == warehouse.uuid
      assert sales_order.total_qty == Decimal.new(100)
      assert sales_order.total_amount == Decimal.new("1000.0")
    end

    test "should succeed with valid request with is_draft is false", %{customer: customer, item: item, stock_uom: stock_uom, warehouse: warehouse} do
      request = %{
        sales_order_uuid: Ecto.UUID.generate(),
        customer_uuid: customer.uuid,
        warehouse_uuid: warehouse.uuid,
        is_draft: false,
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

      assert sales_order.status == :to_deliver_and_bill
      assert sales_order.customer_uuid == customer.uuid
      assert sales_order.warehouse_uuid == warehouse.uuid
      assert sales_order.total_qty == Decimal.new(100)
      assert sales_order.total_amount == Decimal.new("1000.0")
    end
  end

  describe "delete sales order" do
    setup [
      :register_user,
      :create_company,
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
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order
    ]

    test "should succeed with valid request with is_draft is true", %{customer: customer, sales_order: sales_order} do
      sales_order_item = hd(sales_order.items)

      request = %{
        sales_order_uuid: sales_order.uuid,
        customer_uuid: customer.uuid,
        delivery_note_uuid: Ecto.UUID.generate(),
        is_draft: true,
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

    test "should succeed with valid request with is_draft is false", %{customer: customer, sales_order: sales_order} do
      sales_order_item = hd(sales_order.items)

      request = %{
        sales_order_uuid: sales_order.uuid,
        customer_uuid: customer.uuid,
        is_draft: false,
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
      assert delivery_note.status == :to_deliver
    end
  end

  describe "complete delivery note" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order,
      :create_fully_delivery_note
    ]

    test "should succeed with valid request", %{sales_order: sales_order, fully_delivery_note: fully_delivery_note} do
      request = %{
        sales_order_uuid: sales_order.uuid,
        delivery_note_uuid: fully_delivery_note.uuid
      }

      sales_order_item = hd(sales_order.items)

      assert {:ok, before_stock_item} = Turbo.get_by(StockItem, %{warehouse_uuid: sales_order.warehouse_uuid, item_uuid: sales_order_item.item_uuid})
      assert {:ok, updated_delivery_note} = Dispatcher.run(request, :complete_delivery_note)
      assert {:ok, after_stock_item} = Turbo.get_by(StockItem, %{warehouse_uuid: sales_order.warehouse_uuid, item_uuid: sales_order_item.item_uuid})

      # assert
      assert after_stock_item.total_on_hand == decimal_sub(before_stock_item.total_on_hand, sales_order_item.ordered_qty)
      assert updated_delivery_note.status == :completed
    end
  end

  describe "create sales invoice" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order
    ]

    test "should succeed with valid request with is_draft is true", %{sales_order: sales_order} do
      request = %{
        sales_invoice_uuid: Ecto.UUID.generate(),
        sales_order_uuid: sales_order.uuid,
        is_draft: true,
        amount: 1
      }

      assert {:ok, sales_invoice} = Dispatcher.run(request, :create_sales_invoice)

      assert sales_invoice.sales_order_uuid == sales_order.uuid
      assert sales_invoice.customer_uuid == sales_order.customer_uuid
      assert sales_invoice.customer_name == sales_order.customer_name
      assert sales_invoice.status == :draft
    end

    test "should succeed with valid request with is_draft is false", %{sales_order: sales_order} do
      request = %{
        sales_invoice_uuid: Ecto.UUID.generate(),
        sales_order_uuid: sales_order.uuid,
        is_draft: false,
        amount: 1
      }

      assert {:ok, sales_invoice} = Dispatcher.run(request, :create_sales_invoice)

      assert sales_invoice.sales_order_uuid == sales_order.uuid
      assert sales_invoice.customer_uuid == sales_order.customer_uuid
      assert sales_invoice.customer_name == sales_order.customer_name
      assert sales_invoice.status == :unpaid
    end
  end
end
