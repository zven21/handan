defmodule HandanWeb.GraphQL.EnterpriseTest do
  @moduledoc false

  use HandanWeb.ConnCase

  describe "get store" do
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
