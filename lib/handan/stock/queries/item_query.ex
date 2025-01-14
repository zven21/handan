defmodule Handan.Stock.Queries.ItemQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Stock.Projections.{Item, StockItem}

  @doc "get item"
  def get_item(uuid), do: Turbo.get(Item, uuid)

  @doc "list items"
  def list_items, do: Turbo.list(Item)

  @doc "list stock items"
  def list_stock_items, do: Turbo.list(StockItem)
end
