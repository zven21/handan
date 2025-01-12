defmodule HandanWeb.Graphql.Production.BOMTest do
  @moduledoc false

  use HandanWeb.ConnCase

  describe "list BOMs" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_process,
      :create_bom
    ]

    @query """
    query {
    	boms {
    		name
    	}
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn} do
      result = conn |> post("/api", query: @query) |> json_response(200)

      assert result == %{
               "data" => %{
                 "boms" => [%{"name" => "bom-name"}]
               }
             }
    end
  end

  describe "get BOM" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_process,
      :create_bom
    ]

    @query """
    query ($request: IdRequest!) {
    	bom(request: $request) {
    		name
    	}
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, bom: bom} do
      request = %{
        uuid: bom.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "bom" => %{"name" => bom.name}
               }
             }
    end
  end

  describe "create BOM" do
    setup [
      :register_user,
      :create_company,
      :create_item,
      :create_process
    ]

    @mutation """
    mutation ($request: CreateBomRequest!) {
    	createBom(request: $request) {
    		name
    	}
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, item: item, process: process} do
      request = %{
        name: "test_name",
        item_uuid: item.uuid,
        bom_items: [
          %{
            item_uuid: item.uuid,
            qty: 1
          }
        ],
        bom_processes: [
          %{
            process_uuid: process.uuid,
            position: 1
          }
        ]
      }

      result = conn |> post("/api", query: @mutation, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "createBom" => %{"name" => "test_name"}
               }
             }
    end
  end
end
