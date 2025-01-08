defmodule Handan.Enterprise.Projectors.Warehouse do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false

  alias Handan.Enterprise.Events.WarehouseCreated
  alias Handan.Enterprise.Projections.Warehouse

  project(
    %WarehouseCreated{} = evt,
    _meta,
    fn multi ->
      warehouse = %Warehouse{
        uuid: evt.warehouse_uuid,
        name: evt.name,
        address: evt.address,
        is_default: evt.is_default,
        contact_name: evt.contact_name,
        contact_email: evt.contact_email
      }

      Ecto.Multi.insert(multi, :warehouse_created, warehouse)
    end
  )

  def after_update(_event, _metadata, _changes) do
    :ok
  end
end
