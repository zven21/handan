defmodule Handan.Stock do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Stock.Projections.Item

  @doc """
  Get item by uuid.
  """
  def get_item(item_uuid), do: Turbo.get(Item, item_uuid)
end
