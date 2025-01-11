defmodule Handan.Stock.Queries.ItemQuery do
  @moduledoc false

  alias Handan.{Repo, Turbo}
  alias Handan.Stock.Projections.Item

  @doc "get item"
  def get_item(uuid), do: Turbo.get(Item, uuid)

  @doc "list items"
  def list_items, do: Turbo.list(Item)
end
