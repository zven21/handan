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
    ItemDeleted
  }

  alias Handan.Stock.Projections.Item

  project(
    %ItemCreated{} = evt,
    _meta,
    fn multi ->
      item = %Item{
        uuid: evt.item_uuid,
        name: evt.name,
        selling_price: to_decimal(evt.selling_price),
        description: evt.description
      }

      Ecto.Multi.insert(multi, :item_created, item)
    end
  )

  project(%ItemDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :item_deleted, item_query(evt.item_uuid))
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp item_query(uuid) do
    from(c in Item, where: c.uuid == ^uuid)
  end
end
