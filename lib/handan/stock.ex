defmodule Handan.Stock do
  @moduledoc false

  alias Handan.Stock.Queries.ItemQuery

  defdelegate get_item(item_uuid), to: ItemQuery
end
