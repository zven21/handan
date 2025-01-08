defmodule Handan.Purchasing.PurchaseOrderTest do
  use Handan.DataCase

  alias Handan.Turbo
  alias Handan.Dispatcher
  alias Handan.Purchasing.Projections.PurchaseOrder

  describe "create purchase order" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item
    ]

    test "should succeed with valid request", %{supplier: supplier, item: item, stock_uom: stock_uom, warehouse: warehouse} do
      request = %{
        purchase_order_uuid: Ecto.UUID.generate(),
        supplier_uuid: supplier.uuid,
        warehouse_uuid: warehouse.uuid,
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
    end
  end

  # describe "delete purchase order" do
  #   setup [
  #     :register_user,
  #     :create_company,
  #     :create_supplier,
  #     :create_item,
  #     :create_purchase_order
  #   ]

  #   test "should succeed with valid request", %{purchase_order: purchase_order} do
  #     request = %{
  #       purchase_order_uuid: purchase_order.uuid
  #     }

  #     assert :ok = Dispatcher.run(request, :delete_purchase_order)
  #     assert {:error, :not_found} == Turbo.get(PurchaseOrder, purchase_order.uuid)
  #   end
  # end

  # describe "confirm purchase order" do
  #   setup [
  #     :register_user,
  #     :create_company,
  #     :create_supplier,
  #     :create_item,
  #     :create_purchase_order
  #   ]

  #   test "should succeed with valid request", %{purchase_order: purchase_order} do
  #     request = %{
  #       purchase_order_uuid: purchase_order.uuid
  #     }

  #     assert {:ok, purchase_order} = Dispatcher.run(request, :confirm_purchase_order)
  #     assert purchase_order.status == :to_receive_and_bill
  #   end
  # end

  # describe "create receipt note" do
  #   setup [
  #     :register_user,
  #     :create_company,
  #     :create_supplier,
  #     :create_item,
  #     :create_purchase_order
  #   ]

  #   test "should succeed with valid request", %{supplier: supplier, purchase_order: purchase_order} do
  #     purchase_order_item = hd(purchase_order.items)

  #     request = %{
  #       purchase_order_uuid: purchase_order.uuid,
  #       supplier_uuid: supplier.uuid,
  #       receipt_note_uuid: Ecto.UUID.generate(),
  #       receipt_items: [
  #         %{
  #           purchase_order_item_uuid: purchase_order_item.uuid,
  #           actual_qty: 1
  #         }
  #       ]
  #     }

  #     assert {:ok, receipt_note} = Dispatcher.run(request, :create_receipt_note)

  #     assert receipt_note.uuid == request.receipt_note_uuid
  #     assert receipt_note.purchase_order_uuid == purchase_order.uuid
  #     assert receipt_note.supplier_uuid == supplier.uuid
  #     assert receipt_note.status == :draft
  #   end
  # end

  # describe "confirm receipt note" do
  #   setup [
  #     :register_user,
  #     :create_company,
  #     :create_supplier,
  #     :create_item,
  #     :create_purchase_order,
  #     :create_receipt_note
  #   ]

  #   test "should succeed with valid request", %{purchase_order: purchase_order, receipt_note: receipt_note} do
  #     request = %{
  #       purchase_order_uuid: purchase_order.uuid,
  #       receipt_note_uuid: receipt_note.uuid
  #     }

  #     assert {:ok, updated_receipt_note} = Dispatcher.run(request, :confirm_receipt_note)
  #     {:ok, updated_purchase_order} = Turbo.get(PurchaseOrder, purchase_order.uuid)

  #     assert updated_receipt_note.uuid == request.receipt_note_uuid
  #     assert updated_receipt_note.purchase_order_uuid == purchase_order.uuid
  #     assert updated_receipt_note.supplier_uuid == purchase_order.supplier_uuid
  #     assert updated_receipt_note.status == :to_receive

  #     assert updated_purchase_order.status == :to_receive_and_bill
  #     assert updated_purchase_order.receipt_status == :partly_received
  #     assert updated_purchase_order.billing_status == :not_billed
  #   end
  # end

  # describe "complete receipt note" do
  #   setup [
  #     :register_user,
  #     :create_company,
  #     :create_supplier,
  #     :create_item,
  #     :create_purchase_order,
  #     :create_receipt_note,
  #     :confirm_receipt_note
  #   ]

  #   test "should succeed with valid request", %{purchase_order: purchase_order, receipt_note: receipt_note} do
  #     request = %{
  #       purchase_order_uuid: purchase_order.uuid,
  #       receipt_note_uuid: receipt_note.uuid
  #     }

  #     purchase_order_item = hd(purchase_order.items)

  #     assert {:ok, before_stock_item} = Turbo.get_by(StockItem, %{warehouse_uuid: purchase_order.warehouse_uuid, item_uuid: purchase_order_item.item_uuid})
  #     assert {:ok, updated_receipt_note} = Dispatcher.run(request, :complete_receipt_note)
  #     assert {:ok, after_stock_item} = Turbo.get_by(StockItem, %{warehouse_uuid: purchase_order.warehouse_uuid, item_uuid: purchase_order_item.item_uuid})

  #     assert after_stock_item.total_on_hand == decimal_sub(before_stock_item.total_on_hand, purchase_order_item.ordered_qty)
  #     assert updated_receipt_note.status == :completed
  #   end
  # end

  # describe "create purchase invoice" do
  #   setup [
  #     :register_user,
  #     :create_company,
  #     :create_supplier,
  #     :create_item,
  #     :create_purchase_order
  #   ]

  #   test "should succeed with valid request", %{purchase_order: purchase_order} do
  #     request = %{
  #       purchase_invoice_uuid: Ecto.UUID.generate(),
  #       purchase_order_uuid: purchase_order.uuid,
  #       amount: 1
  #     }

  #     assert {:ok, purchase_invoice} = Dispatcher.run(request, :create_purchase_invoice)

  #     assert purchase_invoice.purchase_order_uuid == purchase_order.uuid
  #     assert purchase_invoice.supplier_uuid == purchase_order.supplier_uuid
  #     assert purchase_invoice.supplier_name == purchase_order.supplier_name
  #     assert purchase_invoice.status == :draft
  #   end
  # end

  # describe "confirm purchase invoice" do
  #   setup [
  #     :register_user,
  #     :create_company,
  #     :create_supplier,
  #     :create_item,
  #     :create_purchase_order,
  #     :create_purchase_invoice
  #   ]

  #   test "should succeed with valid request 1", %{purchase_order: purchase_order, purchase_invoice: purchase_invoice} do
  #     request = %{
  #       purchase_invoice_uuid: purchase_invoice.uuid,
  #       purchase_order_uuid: purchase_order.uuid
  #     }

  #     assert {:ok, purchase_invoice} = Dispatcher.run(request, :confirm_purchase_invoice)
  #     assert {:ok, updated_purchase_order} = Turbo.get(PurchaseOrder, purchase_order.uuid)

  #     assert purchase_invoice.purchase_order_uuid == purchase_order.uuid
  #     assert purchase_invoice.supplier_uuid == purchase_order.supplier_uuid
  #     assert purchase_invoice.supplier_name == purchase_order.supplier_name
  #     assert purchase_invoice.amount == Decimal.new(1)
  #     assert purchase_invoice.status == :submitted

  #     assert updated_purchase_order.status == :to_receive
  #     assert updated_purchase_order.receipt_status == :not_received
  #     assert updated_purchase_order.billing_status == :partly_billed
  #   end
  # end
end
