defmodule HandanWeb.GraphQL.Schemas.Stock do
  @moduledoc false

  use HandanWeb.GraphQL.Helpers.GQLSchemaSuite

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  alias Handan.Stock

  object :item do
    field :uuid, :id
    field :name, :string
    field :description, :string
    field :spec, :string
    field :selling_price, :decimal
    field :default_stock_uom_name, :string
    field :default_stock_uom_uuid, :id

    field :bom, :bom, resolve: dataloader(Stock, :bom)
    field :stock_items, list_of(:stock_item), resolve: dataloader(Stock, :stock_items)
    field :stock_uoms, list_of(:stock_uom), resolve: dataloader(Stock, :stock_uoms)
  end

  object :stock_uom do
    field :uuid, :id
    field :conversion_factor, :integer
    field :sequence, :integer
    field :item, :item, resolve: dataloader(Stock, :item)
  end

  object :stock_item do
    field :uuid, :id
    field :total_on_hand, :decimal
    field :item, :item, resolve: dataloader(Stock, :item)
    field :stock_uom, :stock_uom, resolve: dataloader(Stock, :stock_uom)
    field :warehouse, :warehouse, resolve: dataloader(Stock, :warehouse)
  end

  object :inventory_entry do
    field :uuid, :id
    field :actual_qty, :decimal
    field :type, :string
    field :qty_after_transaction, :decimal
    field :thread_uuid, :id
    field :thread_type, :string
    field :item, :item, resolve: dataloader(Stock, :item)
    field :warehouse, :warehouse, resolve: dataloader(Stock, :warehouse)
    field :stock_uom, :stock_uom, resolve: dataloader(Stock, :stock_uom)
  end

  object :stock_queries do
    @desc "get item by uuid"
    field :item, :item do
      arg(:request, non_null(:id_request))

      middleware(M.Authorize, :user)
      resolve(&R.Stock.get_item/2)
    end

    @desc "list items"
    field :items, list_of(:item) do
      middleware(M.Authorize, :user)

      resolve(&R.Stock.list_items/2)
    end
  end

  object :stock_mutations do
    @desc "create item"
    field :create_item, :item do
      arg(:request, non_null(:create_item_request))

      middleware(M.Authorize, :user)

      resolve(&R.Stock.create_item/3)
    end
  end

  input_object :create_item_request do
    field :name, non_null(:string)
    field :spec, :string
    field :stock_uoms, non_null(list_of(:stock_uom_arg))
    field :selling_price, non_null(:decimal)
    field :description, :string
    field :opening_stocks, list_of(:opening_stock_arg)
  end

  input_object :opening_stock_arg do
    field :warehouse_uuid, :id
    field :qty, :float
  end

  input_object :stock_uom_arg do
    field :conversion_factor, :integer
    field :uom_uuid, :id
    field :sequence, :integer
  end
end
