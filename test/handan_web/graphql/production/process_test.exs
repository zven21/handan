defmodule HandanWeb.GraphQL.ProcessTest do
  @moduledoc false

  use HandanWeb.ConnCase

  describe "list processes" do
    setup [
      :register_user,
      :create_company,
      :create_process
    ]

    @query """
    query {
      processes {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn} do
      result = conn |> post("/api", query: @query) |> json_response(200)
    end
  end

  describe "get process" do
    setup [
      :register_user,
      :create_company,
      :create_process
    ]

    @query """
    query ($request: ID!) {
      process(request: $request) {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, process: process} do
      request = %{
        uuid: process.uuid
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)
    end
  end

  describe "create process" do
    setup [
      :register_user,
      :create_company
    ]

    @mutation """
    mutation ($request: CreateProcessRequest!) {
      createProcess(request: $request) {
        name
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn} do
      request = %{
        code: "test_code",
        name: "test_name",
        description: "test_description"
      }

      result = conn |> post("/api", query: @mutation, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "createProcess" => %{"name" => "test_name"}
               }
             }
    end
  end
end
