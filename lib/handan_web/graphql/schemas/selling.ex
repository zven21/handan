defmodule HandanWeb.GraphQL.Schemas.Selling do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]
  import HandanWeb.GraphQL.Helpers.Fields, only: [timestamp_fields: 0]

  alias Handan.Selling

  object :sales_order do
    field :uuid, :id
    field :code, :string
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
    field :customer_uuid, :id
    field :warehouse_name, :string
    field :warehouse_uuid, :id
    field :warehouse, :warehouse, resolve: dataloader(Selling, :warehouse)
    field :customer, :customer, resolve: dataloader(Selling, :customer)

    field :items, list_of(:sales_order_item), resolve: dataloader(Selling, :items)
    field :delivery_notes, list_of(:delivery_note), resolve: dataloader(Selling, :delivery_notes)
    field :sales_invoices, list_of(:sales_invoice), resolve: dataloader(Selling, :sales_invoices)

    timestamp_fields()
  end

  object :sales_order_item do
    field :uuid, :id
    field :item_uuid, :id
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

    timestamp_fields()
  end

  object :sales_invoice do
    field :uuid, :id
    field :code, :string
    field :customer_name, :string
    field :customer_uuid, :id
    field :amount, :decimal

    field :sales_order_uuid, :id
    field :status, :string
    field :sales_order, :sales_order, resolve: dataloader(Selling, :sales_order)
    field :customer, :customer, resolve: dataloader(Selling, :customer)

    timestamp_fields()
  end

  object :delivery_note do
    field :uuid, :id
    field :code, :string
    field :customer_name, :string
    field :status, :string
    field :total_qty, :decimal
    field :total_amount, :decimal
    field :sales_order_uuid, :id
    field :sales_order, :sales_order, resolve: dataloader(Selling, :sales_order)
    field :customer, :customer, resolve: dataloader(Selling, :customer)
    field :warehouse, :warehouse, resolve: dataloader(Selling, :warehouse)
    field :items, list_of(:delivery_note_item), resolve: dataloader(Selling, :items)

    timestamp_fields()
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

    timestamp_fields()
  end

  object :customer do
    field :uuid, :id
    field :name, :string
    field :address, :string
    field :balance, :decimal

    timestamp_fields()
  end

  object :selling_queries do
    @desc "get customer"
    field :customer, :customer do
      arg(:request, non_null(:id_request))

      middleware(M.Authorize, :user)

      resolve(&R.Selling.get_customer/2)
    end

    @desc "list customers"
    field :customers, list_of(:customer) do
      # middleware(M.Authorize, :user)

      resolve(&R.Selling.get_customers/2)
    end

    @desc "get sales order"
    field :sales_order, :sales_order do
      arg(:request, non_null(:sales_order_request))

      middleware(M.Authorize, :user)

      resolve(&R.Selling.get_sales_order/2)
    end

    @desc "list sales orders"
    field :sales_orders, list_of(:sales_order) do
      middleware(M.Authorize, :user)

      resolve(&R.Selling.list_sales_orders/2)
    end

    @desc "get delivery note"
    field :delivery_note, :delivery_note do
      arg(:request, non_null(:delivery_note_request))

      middleware(M.Authorize, :user)

      resolve(&R.Selling.get_delivery_note/2)
    end

    @desc "delivery notes"
    field :delivery_notes, list_of(:delivery_note) do
      middleware(M.Authorize, :user)

      resolve(&R.Selling.list_delivery_notes/2)
    end

    @desc "get sales invoice"
    field :sales_invoice, :sales_invoice do
      arg(:request, non_null(:sales_invoice_request))

      middleware(M.Authorize, :user)

      resolve(&R.Selling.get_sales_invoice/2)
    end

    @desc "sales invoices"
    field :sales_invoices, list_of(:sales_invoice) do
      middleware(M.Authorize, :user)

      resolve(&R.Selling.list_sales_invoices/2)
    end

    @desc "unpaid sales invoices by customer"
    field :unpaid_sales_invoices_by_customer, list_of(:sales_invoice) do
      arg(:request, non_null(:id_request))

      middleware(M.Authorize, :user)

      resolve(&R.Selling.unpaid_sales_invoices_by_customer/2)
    end
  end

  object :selling_mutations do
    @desc "create customer"
    field :create_customer, :customer do
      arg(:request, non_null(:create_customer_request))

      # middleware(M.Authorize, :user)

      resolve(&R.Selling.create_customer/3)
    end

    @desc "create sales order"
    field :create_sales_order, :sales_order do
      arg(:request, non_null(:create_sales_order_request))

      middleware(M.Authorize, :user)

      resolve(&R.Selling.create_sales_order/3)
    end

    @desc "create sales invoice"
    field :create_sales_invoice, :sales_invoice do
      arg(:request, non_null(:create_sales_invoice_request))

      middleware(M.Authorize, :user)

      resolve(&R.Selling.create_sales_invoice/3)
    end

    @desc "create delivery note"
    field :create_delivery_note, :delivery_note do
      arg(:request, non_null(:create_delivery_note_request))

      middleware(M.Authorize, :user)

      resolve(&R.Selling.create_delivery_note/3)
    end

    @desc "complete delivery note"
    field :complete_delivery_note, :delivery_note do
      arg(:request, non_null(:delivery_note_request))

      middleware(M.Authorize, :user)

      resolve(&R.Selling.complete_delivery_note/3)
    end
  end

  input_object :id_request do
    field :uuid, :id
  end

  input_object :sales_order_request do
    field :sales_order_uuid, :id
  end

  input_object :delivery_note_request do
    field :sales_order_uuid, :id
    field :delivery_note_uuid, :id
  end

  input_object :sales_invoice_request do
    field :sales_invoice_uuid, :id
    field :sales_order_uuid, :id
  end

  input_object :create_sales_order_request do
    field :customer_uuid, :id
    field :customer_address, :string
    field :warehouse_uuid, :id
    field :sales_items, list_of(:sales_order_item_arg)
  end

  input_object :create_sales_invoice_request do
    field :sales_order_uuid, :id
    field :amount, :decimal
  end

  input_object :create_delivery_note_request do
    field :sales_order_uuid, :id
    field :delivery_items, list_of(:delivery_note_item_arg)
  end

  input_object :sales_order_item_arg do
    field :item_uuid, :id
    field :unit_price, :float
    field :ordered_qty, :float
    field :stock_uom_uuid, :id
    field :uom_name, :string
  end

  input_object :delivery_note_item_arg do
    field :actual_qty, :decimal
    field :sales_order_item_uuid, :id
  end

  input_object :create_customer_request do
    field :name, non_null(:string)
    field :address, non_null(:string)
  end
end
