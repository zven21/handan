defmodule Handan.Finance.Projectors.PaymentEntry do
  @moduledoc false
  use Commanded.Projections.Ecto, application: Handan.EventApp, repo: Handan.Repo, name: __MODULE__, consistency: :strong
  use Handan.EventSourcing.EventHandlerFailureContext

  import Ecto.Query, warn: false
  import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1]

  alias Handan.Finance.Events.{
    PaymentEntryCreated,
    PaymentEntryDeleted
  }

  alias Handan.Finance.Projections.PaymentEntry

  project(
    %PaymentEntryCreated{} = evt,
    _meta,
    fn multi ->
      payment_entry = %PaymentEntry{
        uuid: evt.payment_entry_uuid,
        party_type: evt.party_type,
        party_uuid: evt.party_uuid,
        payment_method_uuid: evt.payment_method_uuid,
        memo: evt.memo,
        attachments: evt.attachments,
        party_name: evt.party_name,
        purchase_invoice_ids: evt.purchase_invoice_ids,
        sales_invoice_ids: evt.sales_invoice_ids,
        total_amount: to_decimal(evt.total_amount)
      }

      Ecto.Multi.insert(multi, :payment_entry_created, payment_entry)
    end
  )

  project(%PaymentEntryDeleted{} = evt, _meta, fn multi ->
    Ecto.Multi.delete_all(multi, :payment_entry_deleted, payment_entry_query(evt.payment_entry_uuid))
  end)

  def after_update(_event, _metadata, _changes) do
    :ok
  end

  defp payment_entry_query(uuid) do
    from(p in PaymentEntry, where: p.uuid == ^uuid)
  end
end
