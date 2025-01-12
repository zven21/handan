defmodule HandanWeb.Graphql.WorkstationTest do
  @moduledoc false

  use HandanWeb.ConnCase

  describe "list workstations" do
    setup [
      :register_user,
      :create_company,
      :create_workstation
    ]

    @query """
    query {
      workstations {
        name
      }
    }
    """

    @tag :company_owner
    test "should list workstations", %{conn: conn, workstation: workstation} do
      result = conn |> post("/api", query: @query) |> json_response(200)

      assert result == %{
               "data" => %{
                 "workstations" => [%{"name" => workstation.name}]
               }
             }
    end
  end

  describe "get workstation" do
    setup [
      :register_user,
      :create_company,
      :create_workstation
    ]

    @query """
    query ($request: IdRequest!) {
      workstation(request: $request) {
        name
      }
    }
    """

    @tag :company_owner
    test "should get workstation", %{conn: conn, workstation: workstation} do
      result = conn |> post("/api", query: @query, variables: %{request: %{uuid: workstation.uuid}}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "workstation" => %{"name" => workstation.name}
               }
             }
    end
  end

  describe "create workstation" do
    setup [
      :register_user,
      :create_company
    ]

    @query """
    mutation ($request: CreateWorkstationRequest!) {
      CreateWorkstation(request: $request) {
        name
      }
    }
    """

    @tag :company_owner
    test "should create workstation", %{conn: conn} do
      request = %{
        name: "Workstation 1",
        description: "This is a workstation"
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "CreateWorkstation" => %{
                   "name" => "Workstation 1",
                 }
               }
             }
    end
  end
end
