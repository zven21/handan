defmodule Handan.Stock do
  @moduledoc false

  alias Handan.Stock.Queries.{ItemQuery, InventoryEntryQuery}

  defdelegate get_item(item_uuid), to: ItemQuery
  defdelegate list_items, to: ItemQuery
  defdelegate list_stock_items, to: ItemQuery

  defdelegate list_inventory_entries, to: InventoryEntryQuery
end
