defmodule Handan.Stock.Queries.InventoryEntryQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Stock.Projections.InventoryEntry

  @doc "list inventory entries"
  def list_inventory_entries, do: Turbo.list(InventoryEntry)
end
