defmodule Handan.Purchasing.Projectors.Supplier do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false

  alias Handan.Purchasing.Events.{
    SupplierCreated,
    SupplierDeleted
  }

  alias Handan.Purchasing.Projections.Supplier

  project(
    %SupplierCreated{} = evt,
    _meta,
    fn multi ->
      supplier = %Supplier{
        uuid: evt.supplier_uuid,
        name: evt.name,
        address: evt.address
      }

      Ecto.Multi.insert(multi, :supplier_created, supplier)
    end
  )

  project(%SupplierDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :supplier_deleted, supplier_query(evt.supplier_uuid))
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp supplier_query(uuid) do
    from(s in Supplier, where: s.uuid == ^uuid)
  end
end
