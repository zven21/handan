defmodule HandanWeb.GraphQL.FinanceTest do
  @moduledoc false
  use HandanWeb.ConnCase

  describe "list payment entries" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order,
      :create_sales_invoice,
      :create_payment_method,
      :create_payment_entry
    ]

    @query """
    query {
      paymentEntries {
        memo
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, payment_entry: payment_entry} do
      result = conn |> post("/api", query: @query) |> json_response(200)

      assert result == %{
               "data" => %{
                 "paymentEntries" => [%{"memo" => payment_entry.memo}]
               }
             }
    end
  end

  describe "get payment entry" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order,
      :create_sales_invoice,
      :create_payment_method,
      :create_payment_entry
    ]

    @query """
    query ($request: IdRequest!) {
      paymentEntry(request: $request) {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, payment_entry: payment_entry} do
      request = %{
        uuid: payment_entry.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "paymentEntry" => %{
                   "uuid" => payment_entry.uuid
                 }
               }
             }
    end
  end

  describe "list payment methods" do
    setup [
      :register_user,
      :create_payment_method
    ]

    @query """
    query {
      paymentMethods {
        name
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, payment_method: payment_method} do
      result = conn |> post("/api", query: @query) |> json_response(200)

      assert result == %{
               "data" => %{
                 "paymentMethods" => [%{"name" => payment_method.name}]
               }
             }
    end
  end

  describe "get payment method" do
    setup [
      :register_user,
      :create_payment_method
    ]

    @query """
    query ($request: IdRequest!) {
      paymentMethod(request: $request) {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, payment_method: payment_method} do
      request = %{
        uuid: payment_method.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "paymentMethod" => %{
                   "uuid" => payment_method.uuid
                 }
               }
             }
    end
  end

  describe "create payment entry" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order,
      :create_sales_invoice,
      :create_payment_method
    ]

    @query """
    mutation ($request: CreatePaymentEntryRequest!) {
      CreatePaymentEntry(request: $request) {
        memo
      }
    }
    """

    @tag :company_owner
    test "should create payment entry", %{conn: conn, customer: customer, sales_invoice: sales_invoice, payment_method: payment_method} do
      request = %{
        party_type: "customer",
        party_uuid: customer.uuid,
        payment_method_uuid: payment_method.uuid,
        memo: "memo",
        sales_invoice_ids: [sales_invoice.uuid]
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "CreatePaymentEntry" => %{
                   "memo" => request.memo
                 }
               }
             }
    end
  end

  describe "create payment method" do
    setup [
      :register_user
    ]

    @query """
    mutation ($request: CreatePaymentMethodRequest!) {
      CreatePaymentMethod(request: $request) {
        name
      }
    }
    """

    @tag :company_owner
    test "should create payment method", %{conn: conn} do
      request = %{
        name: "payment-method-name"
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "CreatePaymentMethod" => %{
                   "name" => "payment-method-name"
                 }
               }
             }
    end
  end
end
