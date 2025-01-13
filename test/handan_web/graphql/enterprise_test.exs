defmodule HandanWeb.GraphQL.EnterpriseTest do
  @moduledoc false

  use HandanWeb.ConnCase

  describe "list uoms" do
    @query """
    query {
      uoms {
        uuid
        name
      }
    }
    """

    @tag company_owner: true
    test "should succeed with valid request", %{conn: conn} do
      result = conn |> post("/api", query: @query) |> json_response(200)
      assert length(result["data"]["uoms"]) == 13
    end
  end

  describe "list warehouses" do
    @query """
    query {
      warehouses {
        name
      }
    }
    """

    @tag company_owner: true
    test "should succeed with valid request", %{conn: conn} do
      result = conn |> post("/api", query: @query) |> json_response(200)

      assert result == %{
               "data" => %{
                 "warehouses" => [
                   %{
                     "name" => "默认仓库"
                   }
                 ]
               }
             }
    end
  end

  describe "get company" do
    @query """
    query {
      company {
        uuid
        name
      }
    }
    """

    @tag company_owner: true
    test "should succeed with valid request", %{conn: conn, company: company} do
      request = %{}

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "company" => %{
                   "uuid" => company.uuid,
                   "name" => company.name
                 }
               }
             }
    end
  end
end
