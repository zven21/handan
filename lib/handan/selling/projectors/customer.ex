defmodule Handan.Selling.Projectors.Customer do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false

  alias Handan.Selling.Events.{
    CustomerCreated,
    CustomerDeleted
  }

  alias Handan.Selling.Projections.Customer

  project(
    %CustomerCreated{} = evt,
    _meta,
    fn multi ->
      customer = %Customer{
        uuid: evt.customer_uuid,
        name: evt.name,
        address: evt.address,
        balance: 0
      }

      Ecto.Multi.insert(multi, :customer_created, customer)
    end
  )

  project(%CustomerDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :customer_deleted, customer_query(evt.customer_uuid))
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp customer_query(uuid) do
    from(c in Customer, where: c.uuid == ^uuid)
  end
end
