defmodule Handan.Stock.ItemTest do
  @moduledoc false

  use Handan.DataCase

  alias Handan.Dispatcher
  alias Handan.Turbo
  alias Handan.Stock.Projections.Item

  describe "create item" do
    setup [
      :create_store
    ]

    test "should succeed with valid request", %{store: store, uom: uom, uom_2: uom_2, warehouse: warehouse} do
      stock_uoms = [
        %{uom_name: uom.name, uom_uuid: uom.uuid, conversion_factor: 1, sequence: 1},
        %{uom_name: uom_2.name, uom_uuid: uom_2.uuid, conversion_factor: 10, sequence: 2}
      ]

      opening_stocks = [
        %{warehouse_uuid: warehouse.uuid, qty: 100}
      ]

      request = build(:item, name: "item-name", stock_uoms: stock_uoms, store_uuid: store.uuid, opening_stocks: opening_stocks)

      assert {:ok, %Item{} = item} = Dispatcher.run(request, :create_item)
      assert item.name == request.name
      assert length(item.stock_items) == 1
      assert length(item.stock_uoms) == 2
      assert item.inventory_entries |> length == 1
      assert item.inventory_entries |> List.first() |> Map.get(:actual_qty) == Decimal.new(100)
      assert item.inventory_entries |> List.first() |> Map.get(:qty_after_transaction) == Decimal.new(100)
    end

    test "should fail with invalid request" do
      request = build(:item, name: nil)

      assert {:error, changeset} = Dispatcher.run(request, :create_item)
      assert %{name: ["can't be blank"]} == changeset
    end
  end

  describe "delete item" do
    setup [
      :create_store,
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
