defmodule HandanWeb.GraphQL.StockTest do
  @moduledoc false

  use HandanWeb.ConnCase

  describe "get item" do
    setup [
      :register_user,
      :create_company,
      :create_item
    ]

    @query """
    query ($request: IdRequest!) {
      item(request: $request) {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, item: item} do
      request = %{
        uuid: item.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "item" => %{
                   "uuid" => item.uuid
                 }
               }
             }
    end
  end

  describe "list items" do
    setup [
      :register_user,
      :create_company,
      :create_item
    ]

    @query """
    query {
      items {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, item: item} do
      result = conn |> post("/api", query: @query) |> json_response(200)

      assert result == %{
               "data" => %{
                 "items" => [%{"uuid" => item.uuid}]
               }
             }
    end
  end

  describe "create item" do
    setup [
      :register_user,
      :create_company
    ]

    @query """
    mutation ($request: CreateItemRequest!) {
      createItem(request: $request) {
    name
      }
    }
    """

    @tag :company_owner
    test "should create item", %{conn: conn, warehouse: warehouse, uom: uom} do
      request = %{
        name: "item",
        description: "description",
        selling_price: 10.0,
        opening_stocks: [
          %{
            warehouse_uuid: warehouse.uuid,
            qty: 100
          }
        ],
        stock_uoms: [
          %{
            conversion_factor: 1,
            uom_uuid: uom.uuid,
            sequence: 1
          }
        ]
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{"data" => %{"createItem" => %{"name" => "item"}}}
    end
  end
end
