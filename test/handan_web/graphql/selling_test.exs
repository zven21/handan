defmodule HandanWeb.GraphQL.SellingTest do
  @moduledoc false

  use HandanWeb.ConnCase

  describe "get customer" do
    setup [
      :register_user,
      :create_company,
      :create_customer
    ]

    @query """
    query ($request: IdRequest!) {
      customer(request: $request) {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, customer: customer} do
      request = %{
        uuid: customer.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "customer" => %{
                   "uuid" => customer.uuid
                 }
               }
             }
    end
  end

  describe "list customers" do
    setup [
      :register_user,
      :create_company,
      :create_customer
    ]

    @query """
    query {
      customers {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, customer: customer} do
      result = conn |> post("/api", query: @query) |> json_response(200)

      assert result == %{
               "data" => %{
                 "customers" => [%{"uuid" => customer.uuid}]
               }
             }
    end
  end

  describe "get sales order" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order
    ]

    @query """
    query ($request: SalesOrderRequest!) {
      salesOrder(request: $request) {
        uuid
      }
    }
    """
    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, sales_order: sales_order} do
      request = %{
        sales_order_uuid: sales_order.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "salesOrder" => %{
                   "uuid" => sales_order.uuid
                 }
               }
             }
    end
  end

  describe "list sales orders" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order
    ]

    @query """
    query {
      salesOrders {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, sales_order: sales_order} do
      result = conn |> post("/api", query: @query) |> json_response(200)

      assert result == %{
               "data" => %{
                 "salesOrders" => [%{"uuid" => sales_order.uuid}]
               }
             }
    end
  end

  describe "create sales order" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item
    ]

    @query """
    mutation ($request: CreateSalesOrderRequest!) {
      CreateSalesOrder(request: $request) {
        customer_uuid
        items {
          item_name
        }
      }
    }
    """

    @tag :company_owner
    test "should create sales order", %{conn: conn, customer: customer, item: item, stock_uom: stock_uom, warehouse: warehouse} do
      request = %{
        customer_uuid: customer.uuid,
        warehouse_uuid: warehouse.uuid,
        sales_items: [
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
                 "CreateSalesOrder" => %{
                   "customer_uuid" => customer.uuid,
                   "items" => [%{"item_name" => item.name}]
                 }
               }
             }
    end
  end

  describe "confirm sales order" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order
    ]

    @query """
    mutation ($request: SalesOrderRequest!) {
      ConfirmSalesOrder(request: $request) {
        status
        uuid
      }
    }
    """

    @tag :company_owner
    test "should confirm sales order", %{conn: conn, sales_order: sales_order} do
      request = %{
        sales_order_uuid: sales_order.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "ConfirmSalesOrder" => %{
                   "status" => "to_deliver_and_bill",
                   "uuid" => sales_order.uuid
                 }
               }
             }
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

    @query """
    mutation ($request: CreateDeliveryNoteRequest!) {
      CreateDeliveryNote(request: $request) {
        sales_order_uuid
        total_qty
        status
        items {
          item_name
        }
      }
    }
    """

    @tag :company_owner
    test "should create delivery note", %{conn: conn, sales_order: sales_order, item: item} do
      sales_order_item = hd(sales_order.items)

      request = %{
        sales_order_uuid: sales_order.uuid,
        delivery_items: [
          %{
            sales_order_item_uuid: sales_order_item.uuid,
            actual_qty: 100
          }
        ]
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "CreateDeliveryNote" => %{
                   "sales_order_uuid" => sales_order.uuid,
                   "total_qty" => "100",
                   "items" => [%{"item_name" => item.name}],
                   "status" => "draft"
                 }
               }
             }
    end
  end

  describe "confirm delivery note" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order,
      :create_delivery_note
    ]

    @query """
    mutation ($request: DeliveryNoteRequest!) {
      ConfirmDeliveryNote(request: $request) {
        status
        uuid
      }
    }
    """

    @tag :company_owner
    test "should confirm delivery note", %{conn: conn, sales_order: sales_order, delivery_note: delivery_note} do
      request = %{
        sales_order_uuid: sales_order.uuid,
        delivery_note_uuid: delivery_note.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "ConfirmDeliveryNote" => %{
                   "status" => "to_deliver",
                   "uuid" => delivery_note.uuid
                 }
               }
             }
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

    @query """
    mutation ($request: CreateSalesInvoiceRequest!) {
      CreateSalesInvoice(request: $request) {
        status
        amount
      }
    }
    """

    @tag :company_owner
    test "should create sales invoice", %{conn: conn, sales_order: sales_order} do
      request = %{
        sales_order_uuid: sales_order.uuid,
        amount: 1
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "CreateSalesInvoice" => %{
                   "amount" => "1",
                   "status" => "draft"
                 }
               }
             }
    end
  end

  describe "confirm sales invoice" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order,
      :create_sales_invoice
    ]

    @query """
    mutation ($request: SalesInvoiceRequest!) {
      ConfirmSalesInvoice(request: $request) {
        status
        uuid
      }
    }
    """

    @tag :company_owner
    test "should confirm sales invoice", %{conn: conn, sales_order: sales_order, sales_invoice: sales_invoice} do
      request = %{
        sales_order_uuid: sales_order.uuid,
        sales_invoice_uuid: sales_invoice.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "ConfirmSalesInvoice" => %{
                   "status" => "submitted",
                   "uuid" => sales_invoice.uuid
                 }
               }
             }
    end
  end
end
