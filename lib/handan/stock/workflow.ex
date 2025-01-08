defmodule Handan.Stock.Workflow do
  @moduledoc false

  use Commanded.Event.Handler, application: Handan.EventApp, name: __MODULE__, consistency: :strong

  require Logger

  alias Handan.Dispatcher

  alias Handan.Stock.Events.{
    InventoryUnitOutbound,
    InventoryUnitInbound
  }

  def handle(%InventoryUnitOutbound{} = evt, _metadata) do
    Logger.info("InventoryUnitOutbound: #{inspect(evt)}")

    request = %{
      item_uuid: evt.item_uuid,
      warehouse_uuid: evt.warehouse_uuid,
      stock_uom_uuid: evt.stock_uom_uuid,
      qty: evt.actual_qty,
      type: evt.type
    }

    Dispatcher.run(request, :decrease_stock_item)

    :ok
  end

  def handle(%InventoryUnitInbound{} = evt, _metadata) do
    Logger.debug("InventoryUnitInbound: #{inspect(evt)}")

    request = %{
      item_uuid: evt.item_uuid,
      warehouse_uuid: evt.warehouse_uuid,
      stock_uom_uuid: evt.stock_uom_uuid,
      qty: evt.actual_qty,
      type: evt.type
    }

    Dispatcher.run(request, :increase_stock_item)

    :ok
  end
end
