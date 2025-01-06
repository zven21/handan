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

  def create_item(_) do
    {:ok, item} = fixture(:item, name: "item-name")

    [
      item: item
    ]
  end

  def fixture(:store, attrs), do: Dispatcher.run(build(:store, attrs), :create_store)
  def fixture(:item, attrs), do: Dispatcher.run(build(:item, attrs), :create_item)
end
