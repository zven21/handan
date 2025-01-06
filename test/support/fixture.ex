defmodule Handan.Fixture do
  @moduledoc false

  import Handan.Factory

  alias Handan.Dispatcher

  def create_store(_context) do
    {:ok, store} = fixture(:store, name: "store-name")

    uom = hd(store.uoms)
    uom_2 = Enum.at(store.uoms, 1)
    warehouse = hd(store.warehouses)

    [
      store: store,
      uom: uom,
      uom_2: uom_2,
      warehouse: warehouse
    ]
  end

  def create_item(%{store: store, uom: uom, uom_2: uom_2}) do
    stock_uoms = [
      %{uom_name: uom.name, uom_uuid: uom.uuid, conversion_factor: 1, sequence: 1},
      %{uom_name: uom_2.name, uom_uuid: uom_2.uuid, conversion_factor: 10, sequence: 2}
    ]

    {:ok, item} = fixture(:item, name: "item-name", stock_uoms: stock_uoms, store_uuid: store.uuid)

    [
      item: item
    ]
  end

  def fixture(:store, attrs), do: Dispatcher.run(build(:store, attrs), :create_store)
  def fixture(:item, attrs), do: Dispatcher.run(build(:item, attrs), :create_item)
end
