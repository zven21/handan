defmodule HandanWeb.GraphQL.Resolvers.Stock do
  @moduledoc false

  alias Handan.Stock
  alias Handan.Dispatcher

  @doc "get item"
  def get_item(%{request: %{uuid: uuid}}, _), do: Stock.get_item(uuid)

  @doc "list items"
  def list_items(_, _), do: Stock.list_items()

  @doc "create item"
  def create_item(_, %{request: request}, _) do
    request
    |> Map.put(:item_uuid, Ecto.UUID.generate())
    |> Dispatcher.run(:create_item)
  end
end
