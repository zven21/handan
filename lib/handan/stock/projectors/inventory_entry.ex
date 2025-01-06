defmodule Handan.Stock.Projectors.InventoryEntry do
  @moduledoc """
  This module handles the projection of inventory entry events to the database.
  It listens to InventoryEntryCreated events and updates the database accordingly.
  """

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false
  import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1]

  alias Handan.Stock.Events.InventoryEntryCreated
  alias Handan.Stock.Projections.InventoryEntry

  project(
    %InventoryEntryCreated{} = evt,
    _meta,
    fn multi ->
      inventory_entry = %InventoryEntry{
        uuid: evt.inventory_entry_uuid,
        item_uuid: evt.item_uuid,
        warehouse_uuid: evt.warehouse_uuid,
        stock_uom_uuid: evt.stock_uom_uuid,
        actual_qty: to_decimal(evt.actual_qty),
        qty_after_transaction: to_decimal(evt.qty_after_transaction),
        type: evt.type
      }

      Ecto.Multi.insert(multi, :inventory_entry_created, inventory_entry)
    end
  )

  def after_update(_event, _metadata, _changes) do
    :ok
  end
end
