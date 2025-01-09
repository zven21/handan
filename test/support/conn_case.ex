defmodule HandanWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use HandanWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint HandanWeb.Endpoint

      use HandanWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import HandanWeb.ConnCase

      # local imports
      import Handan.Factory
      import Handan.Fixture
    end
  end

  setup tags do
    Handan.Storage.reset!()

    case tags do
      %{company_owner: true} ->
        {:ok, %{user: user}} = Handan.Dispatcher.run(%{email: "test@test.com", password: "123123123", user_uuid: Ecto.UUID.generate()}, :register_user)

        {:ok, %{staff: company_staff} = company} =
          Handan.Dispatcher.run(%{company_uuid: Ecto.UUID.generate(), name: "test company", user_uuid: user.uuid}, :create_company)

        token = Handan.Accounts.generate_user_session_token(user)

        conn =
          Phoenix.ConnTest.build_conn()
          |> Plug.Conn.put_req_header("authorization", "Bearer " <> token)
          |> Plug.Conn.put_req_header("company", company.uuid)

        {:ok, conn: conn, user: user, company: company, staff: hd(company_staff)}

      _ ->
        {:ok, conn: Phoenix.ConnTest.build_conn()}
    end
  end
end
