defmodule Handan.Finance.Projectors.PaymentMethod do
  @moduledoc false

  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false

  alias Handan.Finance.Events.{
    PaymentMethodCreated,
    PaymentMethodDeleted
  }

  alias Handan.Finance.Projections.PaymentMethod

  project(
    %PaymentMethodCreated{} = evt,
    _meta,
    fn multi ->
      payment_method = %PaymentMethod{
        uuid: evt.payment_method_uuid,
        name: evt.name
      }

      Ecto.Multi.insert(multi, :payment_method_created, payment_method)
    end
  )

  project(%PaymentMethodDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :payment_method_deleted, payment_method_query(evt.payment_method_uuid))
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp payment_method_query(uuid) do
    from(p in PaymentMethod, where: p.uuid == ^uuid)
  end
end
