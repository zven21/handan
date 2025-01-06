defmodule Handan.Stock.Projectors.StockItem do
  @moduledoc """
  This module handles the projection of stock item events to the database.
  It listens to StockItemQtyChanged events and updates the database accordingly.
  """

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false
  import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1]

  alias Handan.Stock.Events.{
    OpeningStockCreated
  }

  alias Handan.Stock.Projections.StockItem

  project(
    %OpeningStockCreated{} = evt,
    _meta,
    fn multi ->
      stock_item = %StockItem{
        uuid: evt.stock_item_uuid,
        item_uuid: evt.item_uuid,
        stock_uom_uuid: evt.stock_uom_uuid,
        warehouse_uuid: evt.warehouse_uuid,
        total_on_hand: to_decimal(evt.total_on_hand)
      }

      Ecto.Multi.insert(multi, :opening_stock_created, stock_item)
    end
  )

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  # defp stock_item_query(uuid) do
  #   from(c in StockItem, where: c.uuid == ^uuid)
  # end
end
