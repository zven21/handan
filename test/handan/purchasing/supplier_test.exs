defmodule Handan.Purchasing.SupplierTest do
  @moduledoc false

  use Handan.DataCase

  alias Handan.Turbo
  alias Handan.Dispatcher
  alias Handan.Purchasing.Projections.Supplier

  describe "create supplier" do
    test "should succeed with valid request" do
      request = %{
        supplier_uuid: Ecto.UUID.generate(),
        name: "supplier-name",
        address: "supplier-address"
      }

      assert {:ok, %Supplier{} = supplier} = Dispatcher.run(request, :create_supplier)

      assert supplier.name == request.name
      assert supplier.address == request.address
    end
  end

  describe "delete supplier" do
    setup [
      :create_supplier
    ]

    test "should succeed with valid request", %{supplier: supplier} do
      request = %{
        supplier_uuid: supplier.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_supplier)
      assert {:error, :not_found} == Turbo.get(Supplier, supplier.uuid)
    end
  end
end
