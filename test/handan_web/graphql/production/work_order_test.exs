defmodule HandanWeb.GraphQL.WorkOrderTest do
  @moduledoc false
  use HandanWeb.ConnCase

  describe "get work order" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_bom,
      :create_work_order
    ]

    @query """
    query ($request: IdRequest!) {
      workOrder(request: $request) {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, work_order: work_order} do
      request = %{
        uuid: work_order.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "workOrder" => %{
                   "uuid" => work_order.uuid
                 }
               }
             }
    end
  end

  describe "list work orders" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_bom,
      :create_work_order
    ]

    @query """
    query {
      workOrders {
        item_name
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, work_order: work_order} do
      result = conn |> post("/api", query: @query) |> json_response(200)

      assert result == %{
               "data" => %{
                 "workOrders" => [%{"item_name" => work_order.item_name}]
               }
             }
    end
  end

  describe "create work order" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_bom
    ]

    @query """
    mutation ($request: CreateWorkOrderRequest!) {
      CreateWorkOrder(request: $request) {
        status
      }
    }
    """

    @tag :company_owner
    test "should create work order", %{conn: conn, bom: bom, warehouse: warehouse} do
      request = %{
        warehouse_uuid: warehouse.uuid,
        bom_uuid: bom.uuid,
        planned_qty: 100,
        start_time: "2022-01-01T00:00:00Z",
        end_time: "2022-01-01T08:00:00Z"
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "CreateWorkOrder" => %{
                   "status" => "draft"
                 }
               }
             }
    end
  end

  describe "report job card" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_workstation,
      :create_bom,
      :create_work_order
    ]

    @query """
    mutation ($request: ReportJobCardRequest!) {
      ReportJobCard(request: $request) {
        status
        uuid
      }
    }
    """

    @tag :company_owner
    test "should report job card", %{conn: conn, work_order: work_order} do
      work_order_item = hd(work_order.items)

      request = %{
        work_order_uuid: work_order.uuid,
        work_order_item_uuid: work_order_item.uuid,
        operator_staff_uuid: Ecto.UUID.generate(),
        start_time: "2022-01-01T00:00:00Z",
        end_time: "2022-01-01T08:00:00Z",
        defective_qty: 0,
        produced_qty: 100
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "ReportJobCard" => %{
                   "status" => "draft",
                   "uuid" => work_order.uuid
                 }
               }
             }
    end
  end

  describe "store finish item" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_bom,
      :create_work_order,
      :report_job_card
    ]

    @query """
    mutation ($request: StoreFinishItemRequest!) {
      StoreFinishItem(request: $request) {
        status
        uuid
      }
    }
    """

    @tag :company_owner
    test "should store finish item", %{conn: conn, work_order: work_order} do
      request = %{
        work_order_uuid: work_order.uuid,
        stored_qty: 10
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "StoreFinishItem" => %{
                   "status" => "draft",
                   "uuid" => work_order.uuid
                 }
               }
             }
    end
  end
end
