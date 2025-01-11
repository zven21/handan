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

  # object :stock_queries do
  # end

  # object :stock_mutations do
  # end
end
