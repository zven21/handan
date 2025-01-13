defmodule Handan.Stock.Projectors.Item do
  @moduledoc """
  This module handles the projection of item events to the database.
  It listens to ItemCreated and ItemDeleted events and updates the database accordingly.
  """

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false
  import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1]

  alias Handan.Stock.Events.{
    ItemCreated,
    ItemDeleted,
    StockUOMCreated,
    ItemBOMBinded
  }

  alias Handan.Stock.Projections.{Item, StockUOM}

  project(
    %ItemCreated{} = evt,
    _meta,
    fn multi ->
      item = %Item{
        uuid: evt.item_uuid,
        name: evt.name,
        selling_price: to_decimal(evt.selling_price),
        description: evt.description,
        default_stock_uom_uuid: evt.default_stock_uom_uuid,
        default_stock_uom_name: evt.default_stock_uom_name
      }

      Ecto.Multi.insert(multi, :item_created, item)
    end
  )

  project(
    %ItemBOMBinded{default_bom_uuid: default_bom_uuid} = evt,
    _meta,
    fn multi ->
      set_fields = [
        default_bom_uuid: default_bom_uuid
      ]

      Ecto.Multi.update_all(multi, :item_bom_binded, item_query(evt.item_uuid), set: set_fields)
    end
  )

  project(%ItemDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :item_deleted, item_query(evt.item_uuid))
  end)

  project(
    %StockUOMCreated{} = evt,
    _meta,
    fn multi ->
      stock_uom = %StockUOM{
        uuid: evt.stock_uom_uuid,
        item_uuid: evt.item_uuid,
        uom_uuid: evt.uom_uuid,
        uom_name: evt.uom_name,
        conversion_factor: evt.conversion_factor,
        sequence: evt.sequence
      }

      Ecto.Multi.insert(multi, :stock_uom_created, stock_uom)
    end
  )

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp item_query(uuid) do
    from(c in Item, where: c.uuid == ^uuid)
  end
end
