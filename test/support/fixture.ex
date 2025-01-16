defmodule Handan.Fixture do
  @moduledoc false

  import Handan.Factory

  alias Handan.Repo
  alias Handan.Dispatcher
  alias Handan.Stock
  alias Handan.Enterprise.Projections.{Warehouse, UOM, Staff}

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
    staffs = Repo.all(Staff)

    uom = hd(uoms)
    uom_2 = Enum.at(uoms, 1)
    staff_1 = hd(staffs)
    warehouse = hd(warehouses)

    [
      company: company,
      uom: uom,
      uom_2: uom_2,
      warehouse: warehouse,
      staff: staff_1
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

  def create_purchase_invoice(%{purchase_order: purchase_order}) do
    {:ok, purchase_invoice} = fixture(:purchase_invoice, purchase_order_uuid: purchase_order.uuid, amount: 1)

    [
      purchase_invoice: purchase_invoice
    ]
  end

  def create_bom(%{item: item, uom: uom, warehouse: warehouse}) do
    stock_uoms = [
      %{uom_name: uom.name, uom_uuid: uom.uuid, conversion_factor: 1, sequence: 1}
    ]

    opening_stocks = [
      %{warehouse_uuid: warehouse.uuid, qty: 0}
    ]

    {:ok, sub_item} = fixture(:item, name: "sub-bom-name", stock_uoms: stock_uoms, opening_stocks: opening_stocks)
    {:ok, process} = fixture(:process, name: "process-name")

    {:ok, bom} =
      fixture(:bom,
        name: "bom-name",
        item_uuid: item.uuid,
        bom_items: [
          %{
            item_uuid: sub_item.uuid,
            qty: 10
          }
        ],
        bom_processes: [
          %{
            process_uuid: process.uuid,
            position: 1
          }
        ]
      )

    {:ok, updated_item} = Stock.get_item(item.uuid)

    [
      bom: bom,
      has_bom_item: updated_item
    ]
  end

  def create_process(_context) do
    {:ok, process} = fixture(:process, name: "process-name", description: "process-description")

    [
      process: process
    ]
  end

  def create_workstation(_context) do
    {:ok, workstation} = fixture(:workstation, name: "workstation-name")

    [
      workstation: workstation
    ]
  end

  def create_production_plan(%{item: item}) do
    {:ok, production_plan} =
      fixture(:production_plan,
        title: "production-plan-name",
        start_date: Date.utc_today(),
        end_date: Date.utc_today() |> Date.add(1),
        plan_items: [%{item_uuid: item.uuid, planned_qty: 100}]
      )

    [
      production_plan: production_plan
    ]
  end

  def create_payment_method(_context) do
    {:ok, payment_method} = fixture(:payment_method, name: "payment-method-name")

    [
      payment_method: payment_method
    ]
  end

  def create_work_order(%{has_bom_item: item, warehouse: warehouse}) do
    {:ok, work_order} =
      fixture(:work_order,
        item_uuid: item.uuid,
        item_name: item.name,
        bom_uuid: item.default_bom_uuid,
        stock_uom_uuid: item.default_stock_uom_uuid,
        warehouse_uuid: warehouse.uuid,
        planned_qty: 100,
        start_time: DateTime.utc_now(),
        end_time: DateTime.utc_now() |> DateTime.add(86400)
      )

    [
      work_order: work_order
    ]
  end

  def report_job_card(%{work_order: work_order}) do
    work_order_item = hd(work_order.items)

    {:ok, job_card} =
      fixture(:report_job_card,
        work_order_uuid: work_order.uuid,
        work_order_item_uuid: work_order_item.uuid,
        operator_staff_uuid: Ecto.UUID.generate(),
        start_time: DateTime.utc_now(),
        end_time: DateTime.utc_now() |> DateTime.add(86400),
        produced_qty: 10,
        defective_qty: 1
      )

    {:ok, updated_work_order} = Handan.Production.get_work_order(work_order.uuid)

    [
      job_card: job_card,
      work_order: updated_work_order
    ]
  end

  def create_payment_entry(%{payment_method: payment_method, sales_invoice: sales_invoice}) do
    {:ok, payment_entry} =
      fixture(:payment_entry,
        payment_method_uuid: payment_method.uuid,
        party_type: "customer",
        party_uuid: sales_invoice.customer_uuid,
        memo: "memo",
        sales_invoice_ids: [sales_invoice.uuid]
      )

    [
      payment_entry: payment_entry
    ]
  end

  def fixture(:user, attrs), do: Dispatcher.run(build(:user, attrs), :register_user)
  def fixture(:company, attrs), do: Dispatcher.run(build(:company, attrs), :create_company)
  def fixture(:item, attrs), do: Dispatcher.run(build(:item, attrs), :create_item)
  def fixture(:customer, attrs), do: Dispatcher.run(build(:customer, attrs), :create_customer)
  def fixture(:sales_order, attrs), do: Dispatcher.run(build(:sales_order, attrs), :create_sales_order)
  def fixture(:delivery_note, attrs), do: Dispatcher.run(build(:delivery_note, attrs), :create_delivery_note)
  def fixture(:sales_invoice, attrs), do: Dispatcher.run(build(:sales_invoice, attrs), :create_sales_invoice)
  def fixture(:supplier, attrs), do: Dispatcher.run(build(:supplier, attrs), :create_supplier)
  def fixture(:purchase_order, attrs), do: Dispatcher.run(build(:purchase_order, attrs), :create_purchase_order)
  def fixture(:receipt_note, attrs), do: Dispatcher.run(build(:receipt_note, attrs), :create_receipt_note)
  def fixture(:purchase_invoice, attrs), do: Dispatcher.run(build(:purchase_invoice, attrs), :create_purchase_invoice)
  def fixture(:bom, attrs), do: Dispatcher.run(build(:bom, attrs), :create_bom)
  def fixture(:process, attrs), do: Dispatcher.run(build(:process, attrs), :create_process)
  def fixture(:workstation, attrs), do: Dispatcher.run(build(:workstation, attrs), :create_workstation)
  def fixture(:production_plan, attrs), do: Dispatcher.run(build(:production_plan, attrs), :create_production_plan)
  def fixture(:payment_method, attrs), do: Dispatcher.run(build(:payment_method, attrs), :create_payment_method)
  def fixture(:work_order, attrs), do: Dispatcher.run(build(:work_order, attrs), :create_work_order)
  def fixture(:report_job_card, attrs), do: Dispatcher.run(build(:report_job_card, attrs), :report_job_card)
  def fixture(:payment_entry, attrs), do: Dispatcher.run(build(:payment_entry, attrs), :create_payment_entry)
end
