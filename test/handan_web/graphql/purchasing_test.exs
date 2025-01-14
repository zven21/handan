defmodule HandanWeb.GraphQL.PurchasingTest do
  use HandanWeb.ConnCase

  describe "get supplier" do
    setup [
      :register_user,
      :create_company,
      :create_supplier
    ]

    @query """
    query ($request: IdRequest!) {
      supplier(request: $request) {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, supplier: supplier} do
      request = %{
        uuid: supplier.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "supplier" => %{
                   "uuid" => supplier.uuid
                 }
               }
             }
    end
  end

  describe "list suppliers" do
    setup [
      :register_user,
      :create_company,
      :create_supplier
    ]

    @query """
    query {
      suppliers {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, supplier: supplier} do
      result = conn |> post("/api", query: @query) |> json_response(200)

      assert result == %{
               "data" => %{
                 "suppliers" => [%{"uuid" => supplier.uuid}]
               }
             }
    end
  end

  describe "create supplier" do
    @query """
    mutation ($request: CreateSupplierRequest!) {
      CreateSupplier(request: $request) {
        name
        address
      }
    }
    """

    @tag :company_owner
    test "should create purchase", %{conn: conn} do
      request = %{
        name: "new-supplier",
        address: "address-1"
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "CreateSupplier" => %{"address" => request.address, "name" => request.name}
               }
             }
    end
  end

  describe "get purchase order" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item,
      :create_purchase_order
    ]

    @query """
    query ($request: PurchaseOrderRequest!) {
      purchaseOrder(request: $request) {
        uuid
      }
    }
    """
    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, purchase_order: purchase_order} do
      request = %{
        purchase_order_uuid: purchase_order.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "purchaseOrder" => %{
                   "uuid" => purchase_order.uuid
                 }
               }
             }
    end
  end

  describe "list purchase orders" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item,
      :create_purchase_order
    ]

    @query """
    query {
      purchaseOrders {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, purchase_order: purchase_order} do
      result = conn |> post("/api", query: @query) |> json_response(200)

      assert result == %{
               "data" => %{
                 "purchaseOrders" => [%{"uuid" => purchase_order.uuid}]
               }
             }
    end
  end

  describe "create purchase order" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item
    ]

    @query """
    mutation ($request: CreatePurchaseOrderRequest!) {
      CreatePurchaseOrder(request: $request) {
        supplier_uuid
        status
        items {
          item_name
        }
      }
    }
    """

    @tag :company_owner
    test "should create purchase order", %{conn: conn, supplier: supplier, item: item, stock_uom: stock_uom, warehouse: warehouse} do
      request = %{
        supplier_uuid: supplier.uuid,
        warehouse_uuid: warehouse.uuid,
        purchase_items: [
          %{
            item_uuid: item.uuid,
            ordered_qty: 100,
            unit_price: 10.0,
            stock_uom_uuid: stock_uom.uuid,
            uom_name: stock_uom.uom_name
          }
        ]
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "CreatePurchaseOrder" => %{
                   "status" => "draft",
                   "supplier_uuid" => supplier.uuid,
                   "items" => [%{"item_name" => item.name}]
                 }
               }
             }
    end
  end

  describe "confirm purchase order" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item,
      :create_purchase_order
    ]

    @query """
    mutation ($request: PurchaseOrderRequest!) {
      ConfirmPurchaseOrder(request: $request) {
        status
        uuid
      }
    }
    """

    @tag :company_owner
    test "should confirm purchase order", %{conn: conn, purchase_order: purchase_order} do
      request = %{
        purchase_order_uuid: purchase_order.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "ConfirmPurchaseOrder" => %{
                   "status" => "to_receive_and_bill",
                   "uuid" => purchase_order.uuid
                 }
               }
             }
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

    @query """
    mutation ($request: CreatePurchaseInvoiceRequest!) {
      CreatePurchaseInvoice(request: $request) {
        status
        amount
      }
    }
    """

    @tag :company_owner
    test "should create purchase invoice", %{conn: conn, purchase_order: purchase_order} do
      request = %{
        purchase_order_uuid: purchase_order.uuid,
        amount: 1
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "CreatePurchaseInvoice" => %{
                   "amount" => "1",
                   "status" => "draft"
                 }
               }
             }
    end
  end

  describe "confirm purchase invoice" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item,
      :create_purchase_order,
      :create_purchase_invoice
    ]

    @query """
    mutation ($request: PurchaseInvoiceRequest!) {
      ConfirmPurchaseInvoice(request: $request) {
        status
        uuid
      }
    }
    """

    @tag :company_owner
    test "should confirm purchase invoice", %{conn: conn, purchase_order: purchase_order, purchase_invoice: purchase_invoice} do
      request = %{
        purchase_order_uuid: purchase_order.uuid,
        purchase_invoice_uuid: purchase_invoice.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "ConfirmPurchaseInvoice" => %{
                   "status" => "submitted",
                   "uuid" => purchase_invoice.uuid
                 }
               }
             }
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

    @query """
    mutation ($request: CreateReceiptNoteRequest!) {
      CreateReceiptNote(request: $request) {
        purchase_order_uuid
        total_qty
        status
        items {
          item_name
        }
      }
    }
    """

    @tag :company_owner
    test "should create receipt note", %{conn: conn, purchase_order: purchase_order, item: item} do
      purchase_order_item = hd(purchase_order.items)

      request = %{
        purchase_order_uuid: purchase_order.uuid,
        receipt_items: [
          %{
            purchase_order_item_uuid: purchase_order_item.uuid,
            actual_qty: 100
          }
        ]
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "CreateReceiptNote" => %{
                   "purchase_order_uuid" => purchase_order.uuid,
                   "total_qty" => "100",
                   "items" => [%{"item_name" => item.name}],
                   "status" => "draft"
                 }
               }
             }
    end
  end

  describe "confirm receipt note" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item,
      :create_purchase_order,
      :create_receipt_note
    ]

    @query """
    mutation ($request: ReceiptNoteRequest!) {
      ConfirmReceiptNote(request: $request) {
        status
        uuid
      }
    }
    """

    @tag :company_owner
    test "should confirm receipt note", %{conn: conn, purchase_order: purchase_order, receipt_note: receipt_note} do
      request = %{
        purchase_order_uuid: purchase_order.uuid,
        receipt_note_uuid: receipt_note.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "ConfirmReceiptNote" => %{
                   "status" => "to_receive",
                   "uuid" => receipt_note.uuid
                 }
               }
             }
    end
  end
end
