defmodule HandanWeb.GraphQL.AccountsTest do
  @moduledoc false

  use HandanWeb.ConnCase

  describe "register" do
    @query """
    mutation ($request: RegisterRequest!) {
      register(request: $request) {
        email
      }
    }
    """

    test "should succeed with valid request", %{conn: conn} do
      request = %{
        email: "test@test.com",
        password: "123123123"
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "register" => %{
                   "email" => "test@test.com"
                 }
               }
             }
    end
  end

  describe "login" do
    @query """
    mutation ($request: LoginRequest!) {
      login(request: $request) {
        uuid
      }
    }
    """

    @tag :company_owner
    test "should succeed with valid request", %{conn: conn, user: user} do
      request = %{
        email: user.email,
        password: "123123123"
      }

      result = conn |> post("/api", query: @query, variables: %{request: request}) |> json_response(200)

      assert result == %{
               "data" => %{
                 "login" => %{
                   "uuid" => user.uuid
                 }
               }
             }
    end
  end

  describe "get current user" do
    @query """
    query {
      currentUser {
        email
        uuid
      }
    }
    """

    @tag :company_owner
    test "should return the current user", %{conn: conn, user: user} do
      result = conn |> post("/api", query: @query) |> json_response(200)

      assert result == %{
               "data" => %{
                 "currentUser" => %{
                   "uuid" => user.uuid,
                   "email" => user.email
                 }
               }
             }
    end
  end
end
