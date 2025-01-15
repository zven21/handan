defmodule HandanWeb.GraphQL.Schemas.Purchasing do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]
  import HandanWeb.GraphQL.Helpers.Fields, only: [timestamp_fields: 0]

  alias Handan.Purchasing

  object :supplier do
    field :uuid, :id
    field :name, :string
    field :address, :string

    timestamp_fields()
  end

  object :purchase_order do
    field :uuid, :id
    field :code, :string
    field :status, :string
    field :receipt_status, :string
    field :billing_status, :string
    field :supplier_uuid, :id
    field :supplier_name, :string
    field :supplier_address, :string
    field :total_amount, :decimal
    field :paid_amount, :decimal
    field :remaining_amount, :decimal
    field :total_qty, :decimal
    field :received_qty, :decimal
    field :remaining_qty, :decimal

    field :supplier, :supplier, resolve: dataloader(Purchasing, :supplier)

    field :items, list_of(:purchase_order_item), resolve: dataloader(Purchasing, :items)
    field :purchase_invoices, list_of(:purchase_invoice), resolve: dataloader(Purchasing, :purchase_invoices)
    field :receipt_notes, list_of(:receipt_note), resolve: dataloader(Purchasing, :receipt_notes)

    timestamp_fields()
  end

  object :purchase_order_item do
    field :uuid, :id
    field :item_name, :string
    field :stock_uom_uuid, :id
    field :unit_price, :decimal
    field :amount, :decimal
    field :uom_name, :string
    field :ordered_qty, :decimal
    field :received_qty, :decimal
    field :remaining_qty, :decimal

    timestamp_fields()
  end

  object :purchase_invoice do
    field :uuid, :id
    field :code, :string
    field :status, :string
    field :purchase_order_uuid, :id
    field :amount, :decimal
    field :supplier_name, :string

    timestamp_fields()
  end

  object :receipt_note do
    field :uuid, :id
    field :code, :string
    field :purchase_order_uuid, :id
    field :supplier_name, :string
    field :total_amount, :decimal
    field :total_qty, :decimal
    field :status, :string

    field :items, list_of(:receipt_note_item), resolve: dataloader(Purchasing, :items)
    field :warehouse, :warehouse, resolve: dataloader(Purchasing, :warehouse)

    timestamp_fields()
  end

  object :receipt_note_item do
    field :uuid, :id
    field :item_name, :string
    field :uom_name, :string
    field :stock_uom_uuid, :id
    field :unit_price, :decimal
    field :amount, :decimal
    field :actual_qty, :decimal

    timestamp_fields()
  end

  object :purchasing_queries do
    @desc "get supplier"
    field :supplier, :supplier do
      arg(:request, non_null(:id_request))
      middleware(M.Authorize, :user)

      resolve(&R.Purchasing.get_supplier/2)
    end

    @desc "list suppliers"
    field :suppliers, list_of(:supplier) do
      middleware(M.Authorize, :user)

      resolve(&R.Purchasing.list_suppliers/2)
    end

    @desc "get purchase order"
    field :purchase_order, :purchase_order do
      arg(:request, non_null(:purchase_order_request))
      middleware(M.Authorize, :user)

      resolve(&R.Purchasing.get_purchase_order/2)
    end

    @desc "list purchase orders"
    field :purchase_orders, list_of(:purchase_order) do
      middleware(M.Authorize, :user)

      resolve(&R.Purchasing.list_purchase_orders/2)
    end

    @desc "get purchase invoice"
    field :purchase_invoice, :purchase_invoice do
      arg(:request, non_null(:purchase_invoice_request))
      middleware(M.Authorize, :user)

      resolve(&R.Purchasing.get_purchase_invoice/2)
    end

    @desc "list purchase invoices"
    field :purchase_invoices, list_of(:purchase_invoice) do
      middleware(M.Authorize, :user)

      resolve(&R.Purchasing.list_purchase_invoices/2)
    end

    @desc "get receipt note"
    field :receipt_note, :receipt_note do
      arg(:request, non_null(:receipt_note_request))
      middleware(M.Authorize, :user)

      resolve(&R.Purchasing.get_receipt_note/2)
    end

    @desc "list receipt notes"
    field :receipt_notes, list_of(:receipt_note) do
      middleware(M.Authorize, :user)

      resolve(&R.Purchasing.list_receipt_notes/2)
    end
  end

  object :purchasing_mutations do
    @desc "create supplier"
    field :create_supplier, :supplier do
      arg(:request, non_null(:create_supplier_request))

      middleware(M.Authorize, :user)

      resolve(&R.Purchasing.create_supplier/3)
    end

    @desc "create purchase order"
    field :create_purchase_order, :purchase_order do
      arg(:request, non_null(:create_purchase_order_request))
      middleware(M.Authorize, :user)
      resolve(&R.Purchasing.create_purchase_order/3)
    end

    @desc "confirm purchase order"
    field :confirm_purchase_order, :purchase_order do
      arg(:request, non_null(:purchase_order_request))
      middleware(M.Authorize, :user)

      resolve(&R.Purchasing.confirm_purchase_order/3)
    end

    @desc "create purchase invoice"
    field :create_purchase_invoice, :purchase_invoice do
      arg(:request, non_null(:create_purchase_invoice_request))
      middleware(M.Authorize, :user)
      resolve(&R.Purchasing.create_purchase_invoice/3)
    end

    @desc "confirm purchase invoice"
    field :confirm_purchase_invoice, :purchase_invoice do
      arg(:request, non_null(:purchase_invoice_request))
      middleware(M.Authorize, :user)
      resolve(&R.Purchasing.confirm_purchase_invoice/3)
    end

    @desc "create receipt note"
    field :create_receipt_note, :receipt_note do
      arg(:request, non_null(:create_receipt_note_request))
      middleware(M.Authorize, :user)
      resolve(&R.Purchasing.create_receipt_note/3)
    end

    @desc "confirm receipt note"
    field :confirm_receipt_note, :receipt_note do
      arg(:request, non_null(:receipt_note_request))

      middleware(M.Authorize, :user)

      resolve(&R.Purchasing.confirm_receipt_note/3)
    end

    @desc "complete receipt note"
    field :complete_receipt_note, :receipt_note do
      arg(:request, non_null(:receipt_note_request))
      middleware(M.Authorize, :user)

      resolve(&R.Purchasing.complete_receipt_note/3)
    end
  end

  input_object :purchase_order_request do
    field :purchase_order_uuid, :id
  end

  input_object :purchase_invoice_request do
    field :purchase_invoice_uuid, :id
    field :purchase_order_uuid, :id
  end

  input_object :receipt_note_request do
    field :receipt_note_uuid, :id
    field :purchase_order_uuid, :id
  end

  input_object :create_purchase_order_request do
    field :supplier_uuid, :id
    field :warehouse_uuid, :id
    field :purchase_items, list_of(:purchase_order_item_arg)
  end

  input_object :create_receipt_note_request do
    field :purchase_order_uuid, :id
    field :receipt_items, list_of(:receipt_note_item_arg)
  end

  input_object :create_purchase_invoice_request do
    field :purchase_order_uuid, :id
    field :amount, :decimal
  end

  input_object :receipt_note_item_arg do
    field :purchase_order_item_uuid, :id
    field :actual_qty, :decimal
  end

  input_object :purchase_order_item_arg do
    field :item_uuid, :id
    field :unit_price, :decimal
    field :ordered_qty, :decimal
    field :stock_uom_uuid, :id
    field :uom_name, :string
  end

  input_object :create_supplier_request do
    field :name, non_null(:string)
    field :address, non_null(:string)
  end
end
