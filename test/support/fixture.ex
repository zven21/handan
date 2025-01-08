defmodule Handan.Fixture do
  @moduledoc false

  import Handan.Factory

  alias Handan.Repo
  alias Handan.Dispatcher
  alias Handan.Enterprise.Projections.{Warehouse, UOM}

  def register_user(_context) do
    {:ok, %{user: user}} = fixture(:user, %{email: "test@example.com"})

    [
      user: user
    ]
  end

  def create_company(%{user: user}) do
    {:ok, company} = fixture(:company, name: "company-name", user_uuid: user.uuid)

    uoms = Repo.all(UOM)
    warehouses = Repo.all(Warehouse)

    uom = hd(uoms)
    uom_2 = Enum.at(uoms, 1)
    warehouse = hd(warehouses)

    [
      company: company,
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

    stock_uom = hd(item.stock_uoms)

    [
      item: item,
      stock_uom: stock_uom
    ]
  end

  def create_customer(_context) do
    {:ok, customer} = fixture(:customer, name: "customer-name")

    [
      customer: customer
    ]
  end

  def create_sales_order(%{customer: customer, item: item, stock_uom: stock_uom, warehouse: warehouse}) do
    sales_items = [
      %{
        sales_order_item_uuid: Ecto.UUID.generate(),
        item_uuid: item.uuid,
        ordered_qty: 100,
        unit_price: 10.0,
        stock_uom_uuid: stock_uom.uuid,
        uom_name: stock_uom.uom_name
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

  def create_fully_delivery_note(%{sales_order: sales_order}) do
    sales_order_item = hd(sales_order.items)

    delivery_items = [
      %{
        sales_order_item_uuid: sales_order_item.uuid,
        actual_qty: sales_order_item.ordered_qty
      }
    ]

    {:ok, delivery_note} = fixture(:delivery_note, sales_order_uuid: sales_order.uuid, delivery_items: delivery_items)

    [
      fully_delivery_note: delivery_note
    ]
  end

  def confirm_delivery_note(%{fully_delivery_note: fully_delivery_note}) do
    {:ok, delivery_note} = fixture(:confirm_delivery_note, sales_order_uuid: fully_delivery_note.sales_order_uuid, delivery_note_uuid: fully_delivery_note.uuid)

    [
      delivery_note: delivery_note
    ]
  end

  def create_sales_invoice(%{sales_order: sales_order}) do
    {:ok, sales_invoice} = fixture(:sales_invoice, sales_order_uuid: sales_order.uuid, amount: 1)

    [
      sales_invoice: sales_invoice
    ]
  end

  def create_supplier(_context) do
    {:ok, supplier} = fixture(:supplier, name: "supplier-name", address: "supplier-address")

    [
      supplier: supplier
    ]
  end

  def create_purchase_order(%{supplier: supplier, item: item, stock_uom: stock_uom, warehouse: warehouse}) do
    purchase_items = [
      %{
        purchase_order_item_uuid: Ecto.UUID.generate(),
        item_uuid: item.uuid,
        ordered_qty: 100,
        unit_price: 10.0,
        stock_uom_uuid: stock_uom.uuid,
        uom_name: stock_uom.uom_name
      }
    ]

    {:ok, purchase_order} = fixture(:purchase_order, supplier_uuid: supplier.uuid, warehouse_uuid: warehouse.uuid, purchase_items: purchase_items)

    [
      purchase_order: purchase_order
    ]
  end

  def create_receipt_note(%{purchase_order: purchase_order}) do
    purchase_order_item = hd(purchase_order.items)

    receipt_items = [
      %{
        purchase_order_item_uuid: purchase_order_item.uuid,
        actual_qty: purchase_order_item.ordered_qty
      }
    ]

    {:ok, receipt_note} = fixture(:receipt_note, purchase_order_uuid: purchase_order.uuid, receipt_items: receipt_items)

    [
      receipt_note: receipt_note
    ]
  end

  def confirm_receipt_note(%{receipt_note: receipt_note}) do
    {:ok, receipt_note} = fixture(:confirm_receipt_note, purchase_order_uuid: receipt_note.purchase_order_uuid, receipt_note_uuid: receipt_note.uuid)

    [
      receipt_note: receipt_note
    ]
  end

  def create_purchase_invoice(%{purchase_order: purchase_order}) do
    {:ok, purchase_invoice} = fixture(:purchase_invoice, purchase_order_uuid: purchase_order.uuid, amount: 1)

    [
      purchase_invoice: purchase_invoice
    ]
  end

  def create_bom(%{item: item}) do
    {:ok, bom} = fixture(:bom, name: "bom-name", item_uuid: item.uuid)

    [
      bom: bom
    ]
  end

  def create_process(_context) do
    {:ok, process} = fixture(:process, name: "process-name", description: "process-description")

    [
      process: process
    ]
  end

  def fixture(:user, attrs), do: Dispatcher.run(build(:user, attrs), :register_user)
  def fixture(:company, attrs), do: Dispatcher.run(build(:company, attrs), :create_company)
  def fixture(:item, attrs), do: Dispatcher.run(build(:item, attrs), :create_item)
  def fixture(:customer, attrs), do: Dispatcher.run(build(:customer, attrs), :create_customer)
  def fixture(:sales_order, attrs), do: Dispatcher.run(build(:sales_order, attrs), :create_sales_order)
  def fixture(:delivery_note, attrs), do: Dispatcher.run(build(:delivery_note, attrs), :create_delivery_note)
  def fixture(:confirm_delivery_note, attrs), do: Dispatcher.run(build(:delivery_note, attrs), :confirm_delivery_note)
  def fixture(:sales_invoice, attrs), do: Dispatcher.run(build(:sales_invoice, attrs), :create_sales_invoice)
  def fixture(:supplier, attrs), do: Dispatcher.run(build(:supplier, attrs), :create_supplier)
  def fixture(:purchase_order, attrs), do: Dispatcher.run(build(:purchase_order, attrs), :create_purchase_order)
  def fixture(:receipt_note, attrs), do: Dispatcher.run(build(:receipt_note, attrs), :create_receipt_note)
  def fixture(:confirm_receipt_note, attrs), do: Dispatcher.run(build(:receipt_note, attrs), :confirm_receipt_note)
  def fixture(:purchase_invoice, attrs), do: Dispatcher.run(build(:purchase_invoice, attrs), :create_purchase_invoice)
  def fixture(:bom, attrs), do: Dispatcher.run(build(:bom, attrs), :create_bom)
  def fixture(:process, attrs), do: Dispatcher.run(build(:process, attrs), :create_process)
end
