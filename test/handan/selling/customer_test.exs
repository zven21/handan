defmodule Handan.Selling.CustomerTest do
  @moduledoc false

  use Handan.DataCase

  alias Handan.Turbo
  alias Handan.Dispatcher
  alias Handan.Selling.Projections.Customer

  describe "create customer" do
    test "should succeed with valid request" do
      request = %{
        customer_uuid: Ecto.UUID.generate(),
        name: "customer-name",
        address: "customer-address"
      }

      assert {:ok, %Customer{} = customer} = Dispatcher.run(request, :create_customer)

      assert customer.name == request.name
      assert customer.address == request.address
    end
  end

  describe "delete customer" do
    setup [
      :create_customer
    ]

    test "should succeed with valid request", %{customer: customer} do
      request = %{
        customer_uuid: customer.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_customer)
      assert {:error, :not_found} == Turbo.get(Customer, customer.uuid)
    end
  end
end
