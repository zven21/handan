defmodule HandanWeb.GraphQL.StoreTest do
  @moduledoc false

  use HandanWeb.ConnCase

  describe "get store" do
    @query """
    query {
      currentCompany {
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
                 "currentCompany" => %{
                   "uuid" => company.uuid,
                   "name" => company.name
                 }
               }
             }
    end
  end
end
