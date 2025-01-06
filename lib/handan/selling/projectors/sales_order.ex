defmodule Handan.Selling.Projectors.SalesOrder do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false

  alias Handan.Selling.Events.{
    SalesOrderCreated,
    SalesOrderDeleted
  }

  alias Handan.Selling.Projections.SalesOrder

  project(
    %SalesOrderCreated{} = evt,
    _meta,
    fn multi ->
      sales_order = %SalesOrder{
        uuid: evt.sales_order_uuid,
        customer_uuid: evt.customer_uuid,
        customer_name: evt.customer_name,
        total_amount: evt.total_amount,
        status: "draft"
      }

      Ecto.Multi.insert(multi, :sales_order_created, sales_order)
    end
  )

  project(%SalesOrderDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :sales_order_deleted, sales_order_query(evt.sales_order_uuid))
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp sales_order_query(uuid) do
    from(so in SalesOrder, where: so.uuid == ^uuid)
  end
end
