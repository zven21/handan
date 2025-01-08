defmodule Handan.Enterprise.CompanyTest do
  @moduledoc """
  Test for company.
  """

  use Handan.DataCase

  alias Handan.Dispatcher
  alias Handan.Turbo
  alias Handan.Enterprise.Projections.Company

  describe "create store" do
    setup :register_user

    test "should succeed with valid request", %{user: user} do
      request = build(:company, name: "company-name", user_uuid: user.uuid)

      assert {:ok, %Company{} = company} = Dispatcher.run(request, :create_company)
      assert company.name == request.name
    end
  end

  describe "delete store" do
    setup [
      :register_user,
      :create_company
    ]

    test "should succeed with valid request", %{company: company} do
      request = %{
        company_uuid: company.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_company)
      assert {:error, :not_found} == Turbo.get(Company, company.uuid)
    end
  end
end
