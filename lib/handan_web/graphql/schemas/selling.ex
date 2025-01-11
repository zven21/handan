defmodule HandanWeb.GraphQL.Schemas.Selling do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  alias Handan.Selling

  object :sales_order do
    field :uuid, :id
    field :customer_name, :string
    field :billing_status, :string
    field :delivery_status, :string
    field :status, :string
    field :total_amount, :decimal
    field :paid_amount, :decimal
    field :remaining_amount, :decimal
    field :total_qty, :decimal
    field :delivered_qty, :decimal
    field :remaining_qty, :decimal
    field :warehouse, :warehouse, resolve: dataloader(Selling, :warehouse)
    field :customer, :customer, resolve: dataloader(Selling, :customer)
    field :items, list_of(:sales_order_item), resolve: dataloader(Selling, :items)
  end

  object :sales_order_item do
    field :uuid, :id
    field :item_name, :string
    field :unit_price, :decimal
    field :stock_uom_uuid, :id
    field :uom_name, :string
    field :amount, :decimal
    field :ordered_qty, :decimal
    field :delivered_qty, :decimal
    field :remaining_qty, :decimal
    field :sales_order, :sales_order, resolve: dataloader(Selling, :sales_order)
    field :item, :item, resolve: dataloader(Selling, :item)
  end

  object :sales_invoice do
    field :uuid, :id
    field :customer_name, :string
    field :amount, :decimal

    field :status, :string
    field :sales_order, :sales_order, resolve: dataloader(Selling, :sales_order)
    field :customer, :customer, resolve: dataloader(Selling, :customer)
  end

  object :delivery_note do
    field :uuid, :id
    field :customer_name, :string
    field :status, :string
    field :total_qty, :decimal
    field :total_amount, :decimal
    field :sales_order, :sales_order, resolve: dataloader(Selling, :sales_order)
    field :customer, :customer, resolve: dataloader(Selling, :customer)
    field :items, list_of(:delivery_note_item), resolve: dataloader(Selling, :items)
  end

  object :delivery_note_item do
    field :uuid, :id
    field :actual_qty, :decimal
    field :amount, :decimal
    field :unit_price, :decimal
    field :item_name, :string
    field :stock_uom_uuid, :id
    field :uom_name, :string

    field :delivery_note, :delivery_note, resolve: dataloader(Selling, :delivery_note)
    field :sales_order, :sales_order, resolve: dataloader(Selling, :sales_order)
    field :sales_order_item, :sales_order_item, resolve: dataloader(Selling, :sales_order_item)
    field :item, :item, resolve: dataloader(Selling, :item)
  end

  object :customer do
    field :uuid, :id
    field :name, :string
    field :address, :string
    field :balance, :decimal
  end

  object :selling_queries do
    @desc "get customer"
    field :customer, :customer do
      resolve(fn args, _ -> {:ok, %{}} end)
    end

    @desc "list customers"
    field :customers, list_of(:customer) do
      resolve(fn args, _ -> {:ok, []} end)
    end

    @desc "get sales order"
    field :sales_order, :sales_order do
      resolve(fn args, _ -> {:ok, %{}} end)
    end

    @desc "list sales orders"
    field :sales_orders, list_of(:sales_order) do
      resolve(fn args, _ -> {:ok, []} end)
    end
  end

  object :selling_mutations do
    @desc "create sales order"
    field :create_sales_order, :sales_order do
      resolve(fn args, _ -> {:ok, %{}} end)
    end

    @desc "submit sales order"
    field :submit_sales_order, :sales_order do
      resolve(fn args, _ -> {:ok, %{}} end)
    end

    @desc "create sales invoice"
    field :create_sales_invoice, :sales_invoice do
      resolve(fn args, _ -> {:ok, %{}} end)
    end

    @desc "submit sales invoice"
    field :submit_sales_invoice, :sales_invoice do
      resolve(fn args, _ -> {:ok, %{}} end)
    end

    @desc "create delivery note"
    field :create_delivery_note, :delivery_note do
      resolve(fn args, _ -> {:ok, %{}} end)
    end

    @desc "confirm delivery note"
    field :confirm_delivery_note, :delivery_note do
      resolve(fn args, _ -> {:ok, %{}} end)
    end
  end
end
