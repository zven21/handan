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
      preload: [:uoms, :warehouses]
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

  def match(_), do: {:error, :not_match}
end
