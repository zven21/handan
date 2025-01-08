defmodule Handan.Dispatcher.Matcher do
  @moduledoc false

  @type t :: %__MODULE__{
          command: any(),
          projection: any(),
          preload: [any()],
          result_type: any()
        }

  defstruct command: nil,
            projection: nil,
            preload: [],
            result_type: nil

  require Logger

  @doc "match for command"
  def match(:register_user) do
    return_fn = fn request, info ->
      {:ok, user} = Handan.Turbo.get(info.projection, Map.get(request, :user_uuid), preload: info.preload)
      token = Handan.Accounts.generate_user_session_token(user)
      {:ok, %{user: user, token: token}}
    end

    %__MODULE__{
      command: Handan.Accounts.Commands.RegisterUser,
      projection: Handan.Accounts.Projections.User,
      preload: [],
      result_type: return_fn
    }
  end

  def match(:create_company) do
    %__MODULE__{
      command: Handan.Enterprise.Commands.CreateCompany,
      projection: Handan.Enterprise.Projections.Company,
      result_type: :company_uuid,
      preload: []
    }
  end

  def match(:delete_company) do
    %__MODULE__{
      command: Handan.Enterprise.Commands.DeleteCompany,
      projection: Handan.Enterprise.Projections.Company
    }
  end

  def match(:create_item) do
    %__MODULE__{
      command: Handan.Stock.Commands.CreateItem,
      projection: Handan.Stock.Projections.Item,
      result_type: :item_uuid,
      preload: [:inventory_entries, :stock_items, :stock_uoms]
    }
  end

  def match(:delete_item) do
    %__MODULE__{
      command: Handan.Stock.Commands.DeleteItem,
      projection: Handan.Stock.Projections.Item
    }
  end

  def match(:increase_stock_item) do
    %__MODULE__{
      command: Handan.Stock.Commands.IncreaseStockItem,
      projection: Handan.Stock.Projections.Item,
      result_type: :item_uuid,
      preload: [:inventory_entries, :stock_items, :stock_uoms]
    }
  end

  def match(:decrease_stock_item) do
    %__MODULE__{
      command: Handan.Stock.Commands.DecreaseStockItem,
      projection: Handan.Stock.Projections.Item,
      result_type: :item_uuid,
      preload: [:inventory_entries, :stock_items, :stock_uoms]
    }
  end

  # selling
  def match(:create_customer) do
    %__MODULE__{
      command: Handan.Selling.Commands.CreateCustomer,
      projection: Handan.Selling.Projections.Customer,
      result_type: :customer_uuid
    }
  end

  def match(:delete_customer) do
    %__MODULE__{
      command: Handan.Selling.Commands.DeleteCustomer,
      projection: Handan.Selling.Projections.Customer
    }
  end

  def match(:create_sales_order) do
    %__MODULE__{
      command: Handan.Selling.Commands.CreateSalesOrder,
      projection: Handan.Selling.Projections.SalesOrder,
      result_type: :sales_order_uuid,
      preload: [:customer, :warehouse, :items]
    }
  end

  def match(:confirm_sales_order) do
    %__MODULE__{
      command: Handan.Selling.Commands.ConfirmSalesOrder,
      projection: Handan.Selling.Projections.SalesOrder,
      result_type: :sales_order_uuid,
      preload: []
    }
  end

  def match(:delete_sales_order) do
    %__MODULE__{
      command: Handan.Selling.Commands.DeleteSalesOrder,
      projection: Handan.Selling.Projections.SalesOrder
    }
  end

  def match(:create_delivery_note) do
    %__MODULE__{
      command: Handan.Selling.Commands.CreateDeliveryNote,
      projection: Handan.Selling.Projections.DeliveryNote,
      result_type: :delivery_note_uuid,
      preload: [:sales_order, :items]
    }
  end

  def match(:confirm_delivery_note) do
    %__MODULE__{
      command: Handan.Selling.Commands.ConfirmDeliveryNote,
      projection: Handan.Selling.Projections.DeliveryNote,
      result_type: :delivery_note_uuid,
      preload: []
    }
  end

  def match(:create_sales_invoice) do
    %__MODULE__{
      command: Handan.Selling.Commands.CreateSalesInvoice,
      projection: Handan.Selling.Projections.SalesInvoice,
      result_type: :sales_invoice_uuid,
      preload: []
    }
  end

  def match(:confirm_sales_invoice) do
    %__MODULE__{
      command: Handan.Selling.Commands.ConfirmSalesInvoice,
      projection: Handan.Selling.Projections.SalesInvoice,
      result_type: :sales_invoice_uuid,
      preload: []
    }
  end

  def match(:complete_delivery_note) do
    %__MODULE__{
      command: Handan.Selling.Commands.CompleteDeliveryNote,
      projection: Handan.Selling.Projections.DeliveryNote,
      result_type: :delivery_note_uuid,
      preload: []
    }
  end

  def match(:create_supplier) do
    %__MODULE__{
      command: Handan.Purchasing.Commands.CreateSupplier,
      projection: Handan.Purchasing.Projections.Supplier,
      result_type: :supplier_uuid,
      preload: []
    }
  end

  def match(:delete_supplier) do
    %__MODULE__{
      command: Handan.Purchasing.Commands.DeleteSupplier,
      projection: Handan.Purchasing.Projections.Supplier
    }
  end

  def match(_), do: {:error, :not_match}
end
