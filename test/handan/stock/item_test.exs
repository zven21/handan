defmodule Handan.Stock.ItemTest do
  @moduledoc false

  use Handan.DataCase

  alias Handan.Dispatcher
  alias Handan.Turbo
  alias Handan.Stock.Projections.Item

  describe "create item" do
    test "should succeed with valid request" do
      request = build(:item, name: "item-name")

      assert {:ok, %Item{} = item} = Dispatcher.run(request, :create_item)

      assert item.name == request.name
    end

    test "should fail with invalid request" do
      request = build(:item, name: nil)

      assert {:error, changeset} = Dispatcher.run(request, :create_item)
      assert %{name: ["can't be blank"]} == changeset
    end
  end

  describe "delete item" do
    setup [
      :create_item
    ]

    test "should succeed with valid request", %{item: item} do
      request = %{
        item_uuid: item.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_item)
      assert {:error, :not_found} == Turbo.get(Item, item.uuid)
    end
  end
end
