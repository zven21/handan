defmodule Handan.Enterprise.StoreTest do
  use Handan.DataCase

  alias Handan.Dispatcher
  alias Handan.Turbo
  alias Handan.Enterprise.Projections.Store

  describe "create store" do
    test "should succeed with valid request" do
      request = build(:store, name: "store-name")

      assert {:ok, %Store{} = store} = Dispatcher.run(request, :create_store)
      assert store.name == request.name
    end
  end

  describe "delete store" do
    setup [
      :create_store
    ]

    test "should succeed with valid request", %{store: store} do
      request = %{
        store_uuid: store.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_store)
      assert {:error, :not_found} == Turbo.get(Store, store.uuid)
    end
  end
end
