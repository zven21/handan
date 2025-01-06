defmodule Handan.Stock.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Handan.Stock.Aggregates.{
    Item
  }

  alias Handan.Stock.Commands.{
    CreateItem,
    DeleteItem
  }

  if Mix.env() == :dev do
    middleware(Commanded.Middleware.Logger)
  end

  middleware(Handan.EventSourcing.Middleware.Enrich)

  identify(Item, by: :item_uuid, prefix: "item-")

  dispatch(
    [
      CreateItem,
      DeleteItem
    ],
    to: Item,
    lifespan: Item
  )
end
