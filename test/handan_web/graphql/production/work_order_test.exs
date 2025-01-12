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
        item_uuid
        status
      }
    }
    """

    @tag :company_owner
    test "should create work order", %{conn: conn, item: item, warehouse: warehouse} do
      request = %{
        item_uuid: item.uuid,
        warehouse_uuid: warehouse.uuid,
        bom_uuid: item.default_bom_uuid,
        stock_uom_uuid: item.default_stock_uom_uuid,
        planned_qty: 100,
        start_time: "2022-01-01T00:00:00Z",
        end_time: "2022-01-01T08:00:00Z"
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "CreateWorkOrder" => %{
                   "status" => "draft",
                   "item_uuid" => item.uuid
                 }
               }
             }
    end
  end

  # describe "report job card" do
  #   setup [
  #     :register_user,
  #     :create_company,
  #     :create_item,
  #     :create_warehouse,
  #     :create_work_order
  #   ]

  #   @query """
  #   mutation ($request: ReportJobCardRequest!) {
  #     ReportJobCard(request: $request) {
  #       status
  #       uuid
  #     }
  #   }
  #   """

  #   @tag :company_owner
  #   test "should report job card", %{conn: conn, work_order: work_order} do
  #     request = %{
  #       work_order_uuid: work_order.uuid,
  #       start_time: "2022-01-01T00:00:00Z",
  #       end_time: "2022-01-01T08:00:00Z",
  #       defective_qty: 0,
  #       produced_qty: 100
  #     }

  #     result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

  #     assert result == %{
  #              "data" => %{
  #                "ReportJobCard" => %{
  #                  "status" => "done",
  #                  "uuid" => work_order.uuid
  #                }
  #              }
  #            }
  #   end
  # end
end
