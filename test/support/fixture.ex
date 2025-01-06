defmodule Handan.Fixture do
  @moduledoc false

  import Handan.Factory

  alias Handan.Repo
  alias Handan.Dispatcher
  alias Handan.Enterprise.Projections.{Warehouse, UOM}

  def create_store(_context) do
    {:ok, store} = fixture(:store, name: "store-name")

    uoms = Repo.all(UOM)
    warehouses = Repo.all(Warehouse)

    uom = hd(uoms)
    uom_2 = Enum.at(uoms, 1)
    warehouse = hd(warehouses)

    [
      store: store,
      uom: uom,
      uom_2: uom_2,
      warehouse: warehouse
    ]
  end

  def create_item(%{store: store, uom: uom, uom_2: uom_2, warehouse: warehouse}) do
    stock_uoms = [
      %{uom_name: uom.name, uom_uuid: uom.uuid, conversion_factor: 1, sequence: 1},
      %{uom_name: uom_2.name, uom_uuid: uom_2.uuid, conversion_factor: 10, sequence: 2}
    ]

    opening_stocks = [
      %{warehouse_uuid: warehouse.uuid, qty: 100}
    ]

    {:ok, item} = fixture(:item, name: "item-name", stock_uoms: stock_uoms, opening_stocks: opening_stocks)

    [
      item: item
    ]
  end

  def create_customer(_context) do
    {:ok, customer} = fixture(:customer, name: "customer-name")

    [
      customer: customer
    ]
  end

  def fixture(:store, attrs), do: Dispatcher.run(build(:store, attrs), :create_store)
  def fixture(:item, attrs), do: Dispatcher.run(build(:item, attrs), :create_item)
  def fixture(:customer, attrs), do: Dispatcher.run(build(:customer, attrs), :create_customer)
end
