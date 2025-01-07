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

  def create_item(%{uom: uom, uom_2: uom_2, warehouse: warehouse}) do
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

  def create_sales_order(%{customer: customer, item: item, warehouse: warehouse}) do
    sales_items = [
      %{
        sales_order_item_uuid: Ecto.UUID.generate(),
        item_uuid: item.uuid,
        ordered_qty: 100,
        unit_price: 10.0
      }
    ]

    {:ok, sales_order} = fixture(:sales_order, customer_uuid: customer.uuid, warehouse_uuid: warehouse.uuid, sales_items: sales_items)

    [
      sales_order: sales_order
    ]
  end

  def create_delivery_note(%{sales_order: sales_order}) do
    sales_order_item = hd(sales_order.items)

    delivery_items = [
      %{
        sales_order_item_uuid: sales_order_item.uuid,
        actual_qty: 1
      }
    ]

    {:ok, delivery_note} = fixture(:delivery_note, sales_order_uuid: sales_order.uuid, delivery_items: delivery_items)

    [
      delivery_note: delivery_note
    ]
  end

  def create_fully_delivery_note(%{store: store, sales_order: sales_order}) do
    sales_order_item = hd(sales_order.items)

    delivery_items = [
      %{
        sales_order_item_uuid: sales_order_item.uuid,
        actual_qty: sales_order_item.ordered_qty
      }
    ]

    {:ok, delivery_note} = fixture(:delivery_note, store_uuid: store.uuid, sales_order_uuid: sales_order.uuid, delivery_items: delivery_items)

    [
      fully_delivery_note: delivery_note
    ]
  end

  def fixture(:store, attrs), do: Dispatcher.run(build(:store, attrs), :create_store)
  def fixture(:item, attrs), do: Dispatcher.run(build(:item, attrs), :create_item)
  def fixture(:customer, attrs), do: Dispatcher.run(build(:customer, attrs), :create_customer)
  def fixture(:sales_order, attrs), do: Dispatcher.run(build(:sales_order, attrs), :create_sales_order)
  def fixture(:delivery_note, attrs), do: Dispatcher.run(build(:delivery_note, attrs), :create_delivery_note)
end
