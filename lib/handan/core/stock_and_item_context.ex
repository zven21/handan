defmodule Handan.Core.StockAndItemContext do
  @moduledoc """
  item mvp
  """

  defmodule Item do
    @type t :: %__MODULE__{
            id: integer,
            name: String.t(),
            description: String.t(),
            default_item_uom_id: integer,
            selling_price: float,
            stock_uoms: [StockUOM.t()],
            stock_items: [StockItem.t()]
          }

    defstruct id: nil,
              name: nil,
              description: nil,
              default_item_uom_id: nil,
              selling_price: nil,
              stock_uoms: [],
              stock_items: []
  end

  defmodule Warehouse do
    @type t :: %__MODULE__{
            id: integer,
            name: String.t(),
            description: String.t()
          }

    defstruct id: nil,
              name: nil,
              description: nil
  end

  defmodule StockItem do
    @type t :: %__MODULE__{
            id: integer,
            item_id: integer,
            item_uom_id: integer,
            warehouse_id: integer,
            total_on_hand: float
          }

    defstruct id: nil,
              item_id: nil,
              item_uom_id: nil,
              warehouse_id: nil,
              total_on_hand: nil
  end

  defmodule StockLedgerEntry do
    @type t :: %__MODULE__{
            id: integer,
            stock_item_id: integer,
            warehouse_id: integer,
            item_id: integer,
            quantity: float
          }

    defstruct id: nil,
              stock_item_id: nil,
              warehouse_id: nil,
              item_id: nil,
              quantity: nil
  end

  defmodule UOM do
    @type t :: %__MODULE__{
            id: integer,
            name: String.t(),
            description: String.t()
          }

    defstruct id: nil,
              name: nil,
              description: nil
  end

  defmodule ItemUOM do
    @type t :: %__MODULE__{
            id: integer,
            item_id: integer,
            uom_id: integer,
            position: integer,
            conversion_factor: float
          }

    defstruct id: nil,
              item_id: nil,
              uom_id: nil,
              position: nil,
              conversion_factor: nil
  end

  def create_sample_data do
    # 创建单位（UOM）
    piece_unit = %UOM{
      id: 1,
      name: "件",
      description: "用于表示单个物品，比如一张桌子计为 1 件"
    }

    liter_unit = %UOM{
      id: 2,
      name: "升",
      description: "用于衡量液体体积，像油漆以升为单位计量"
    }

    # 创建物品单位换算（ItemUOM）
    table_item_uom = %ItemUOM{
      id: 1,
      item_id: 1,
      uom_id: piece_unit.id,
      position: 1,
      conversion_factor: 1
    }

    paint_item_uom = %ItemUOM{
      id: 2,
      item_id: 2,
      uom_id: liter_unit.id,
      position: 1,
      conversion_factor: 1
    }

    # 创建物品（Item）
    table_item = %Item{
      id: 1,
      name: "实木餐桌",
      description: "采用优质木材打造的家用餐桌",
      default_item_uom_id: 1,
      selling_price: 500.0,
      stock_uoms: [table_item_uom],
      stock_items: []
    }

    paint_item = %Item{
      id: 2,
      name: "木器漆",
      description: "专为木质家具表面涂装设计的油漆",
      default_item_uom_id: 2,
      selling_price: 50.0,
      stock_uoms: [paint_item_uom],
      stock_items: []
    }

    # 创建仓库（Warehouse）
    main_warehouse = %Warehouse{
      id: 1,
      name: "主仓库",
      description: "公司存放各类物品的主要场所"
    }

    # 创建库存物品（StockItem）
    table_stock_item = %StockItem{
      id: 1,
      item_id: 1,
      item_uom_id: 1,
      warehouse_id: 1,
      total_on_hand: 10
    }

    paint_stock_item = %StockItem{
      id: 2,
      item_id: 2,
      item_uom_id: 2,
      warehouse_id: 1,
      total_on_hand: 5
    }

    # 更新物品的库存物品列表
    updated_table_item = %Item{
      table_item
      | stock_items: [table_stock_item]
    }

    updated_paint_item = %Item{
      paint_item
      | stock_items: [paint_stock_item]
    }

    # 创建库存分类账条目（StockLedgerEntry）
    table_ledger_entry = %StockLedgerEntry{
      id: 1,
      stock_item_id: 1,
      warehouse_id: 1,
      item_id: 1,
      quantity: 10
    }

    paint_ledger_entry = %StockLedgerEntry{
      id: 2,
      stock_item_id: 2,
      warehouse_id: 1,
      item_id: 2,
      quantity: 5
    }

    {updated_table_item, updated_paint_item, main_warehouse, table_ledger_entry,
     paint_ledger_entry}
  end
end
