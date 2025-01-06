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

  def match(:create_store) do
    %__MODULE__{
      command: Handan.Enterprise.Commands.CreateStore,
      projection: Handan.Enterprise.Projections.Store,
      result_type: :store_uuid,
      preload: []
    }
  end

  def match(:delete_store) do
    %__MODULE__{
      command: Handan.Enterprise.Commands.DeleteStore,
      projection: Handan.Enterprise.Projections.Store
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
      preload: [:customer, :warehouse, :sales_order_items]
    }
  end

  def match(:delete_sales_order) do
    %__MODULE__{
      command: Handan.Selling.Commands.DeleteSalesOrder,
      projection: Handan.Selling.Projections.SalesOrder
    }
  end

  def match(_), do: {:error, :not_match}
end
