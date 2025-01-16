defmodule Handan.Purchasing.PurchaseOrderTest do
  use Handan.DataCase

  import Handan.Infrastructure.DecimalHelper, only: [decimal_add: 2]

  alias Handan.Turbo
  alias Handan.Dispatcher
  alias Handan.Purchasing.Projections.PurchaseOrder
  alias Handan.Stock.Projections.StockItem

  describe "create purchase order" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item
    ]

    test "should succeed with valid request when is_draft is false", %{supplier: supplier, item: item, stock_uom: stock_uom, warehouse: warehouse} do
      request = %{
        purchase_order_uuid: Ecto.UUID.generate(),
        supplier_uuid: supplier.uuid,
        warehouse_uuid: warehouse.uuid,
        is_draft: false,
        purchase_items: [
          %{
            purchase_order_item_uuid: Ecto.UUID.generate(),
            item_uuid: item.uuid,
            ordered_qty: 100,
            unit_price: 10.0,
            stock_uom_uuid: stock_uom.uuid,
            uom_name: stock_uom.uom_name
          }
        ]
      }

      assert {:ok, %PurchaseOrder{} = purchase_order} = Dispatcher.run(request, :create_purchase_order)

      assert purchase_order.supplier_uuid == supplier.uuid
      assert purchase_order.warehouse_uuid == warehouse.uuid
      assert purchase_order.total_qty == Decimal.new(100)
      assert purchase_order.total_amount == Decimal.new("1000.0")
      assert length(purchase_order.items) == 1
      assert purchase_order.status == :to_receive_and_bill
    end

    test "should succeed with valid request when is_draft is true", %{supplier: supplier, item: item, stock_uom: stock_uom, warehouse: warehouse} do
      request = %{
        purchase_order_uuid: Ecto.UUID.generate(),
        supplier_uuid: supplier.uuid,
        warehouse_uuid: warehouse.uuid,
        is_draft: true,
        purchase_items: [
          %{
            purchase_order_item_uuid: Ecto.UUID.generate(),
            item_uuid: item.uuid,
            ordered_qty: 100,
            unit_price: 10.0,
            stock_uom_uuid: stock_uom.uuid,
            uom_name: stock_uom.uom_name
          }
        ]
      }

      assert {:ok, %PurchaseOrder{} = purchase_order} = Dispatcher.run(request, :create_purchase_order)

      assert purchase_order.supplier_uuid == supplier.uuid
      assert purchase_order.warehouse_uuid == warehouse.uuid
      assert purchase_order.total_qty == Decimal.new(100)
      assert purchase_order.total_amount == Decimal.new("1000.0")
      assert length(purchase_order.items) == 1
      assert purchase_order.status == :draft
    end
  end

  describe "delete purchase order" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item,
      :create_purchase_order
    ]

    test "should succeed with valid request", %{purchase_order: purchase_order} do
      request = %{
        purchase_order_uuid: purchase_order.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_purchase_order)
      assert {:error, :not_found} == Turbo.get(PurchaseOrder, purchase_order.uuid)
    end
  end

  describe "create receipt note" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item,
      :create_purchase_order
    ]

    test "should succeed with valid request when is_draft is true", %{supplier: supplier, purchase_order: purchase_order} do
      purchase_order_item = hd(purchase_order.items)

      request = %{
        purchase_order_uuid: purchase_order.uuid,
        supplier_uuid: supplier.uuid,
        is_draft: true,
        receipt_note_uuid: Ecto.UUID.generate(),
        receipt_items: [
          %{
            purchase_order_item_uuid: purchase_order_item.uuid,
            actual_qty: 1
          }
        ]
      }

      assert {:ok, receipt_note} = Dispatcher.run(request, :create_receipt_note)

      assert receipt_note.uuid == request.receipt_note_uuid
      assert receipt_note.purchase_order_uuid == purchase_order.uuid
      assert receipt_note.supplier_uuid == supplier.uuid
      assert receipt_note.status == :draft
    end

    test "should succeed with valid request when is_draft is false", %{supplier: supplier, purchase_order: purchase_order} do
      purchase_order_item = hd(purchase_order.items)

      request = %{
        purchase_order_uuid: purchase_order.uuid,
        supplier_uuid: supplier.uuid,
        is_draft: false,
        receipt_note_uuid: Ecto.UUID.generate(),
        receipt_items: [
          %{
            purchase_order_item_uuid: purchase_order_item.uuid,
            actual_qty: 1
          }
        ]
      }

      assert {:ok, receipt_note} = Dispatcher.run(request, :create_receipt_note)

      assert receipt_note.uuid == request.receipt_note_uuid
      assert receipt_note.purchase_order_uuid == purchase_order.uuid
      assert receipt_note.supplier_uuid == supplier.uuid
      assert receipt_note.status == :to_receive
    end
  end

  describe "complete receipt note" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item,
      :create_purchase_order,
      :create_receipt_note
    ]

    test "should succeed with valid request", %{purchase_order: purchase_order, receipt_note: receipt_note} do
      request = %{
        purchase_order_uuid: purchase_order.uuid,
        receipt_note_uuid: receipt_note.uuid
      }

      purchase_order_item = hd(purchase_order.items)

      assert {:ok, before_stock_item} = Turbo.get_by(StockItem, %{warehouse_uuid: purchase_order.warehouse_uuid, item_uuid: purchase_order_item.item_uuid})
      assert {:ok, updated_receipt_note} = Dispatcher.run(request, :complete_receipt_note)
      assert {:ok, after_stock_item} = Turbo.get_by(StockItem, %{warehouse_uuid: purchase_order.warehouse_uuid, item_uuid: purchase_order_item.item_uuid})

      assert after_stock_item.total_on_hand == decimal_add(before_stock_item.total_on_hand, purchase_order_item.ordered_qty)
      assert updated_receipt_note.status == :completed
    end
  end

  describe "create purchase invoice" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item,
      :create_purchase_order
    ]

    test "should succeed with valid request when is_draft is false", %{purchase_order: purchase_order} do
      request = %{
        purchase_invoice_uuid: Ecto.UUID.generate(),
        purchase_order_uuid: purchase_order.uuid,
        amount: 1,
        is_draft: false
      }

      assert {:ok, purchase_invoice} = Dispatcher.run(request, :create_purchase_invoice)

      assert purchase_invoice.purchase_order_uuid == purchase_order.uuid
      assert purchase_invoice.supplier_uuid == purchase_order.supplier_uuid
      assert purchase_invoice.supplier_name == purchase_order.supplier_name
      assert purchase_invoice.status == :unpaid
    end

    test "should succeed with valid request when is_draft is true", %{purchase_order: purchase_order} do
      request = %{
        purchase_invoice_uuid: Ecto.UUID.generate(),
        purchase_order_uuid: purchase_order.uuid,
        amount: 1,
        is_draft: true
      }

      assert {:ok, purchase_invoice} = Dispatcher.run(request, :create_purchase_invoice)

      assert purchase_invoice.purchase_order_uuid == purchase_order.uuid
      assert purchase_invoice.supplier_uuid == purchase_order.supplier_uuid
      assert purchase_invoice.supplier_name == purchase_order.supplier_name
      assert purchase_invoice.status == :draft
    end
  end
end
