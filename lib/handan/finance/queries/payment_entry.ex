defmodule Handan.Finance.Queries.PaymentEntryQuery do
  @moduledoc false

  alias Handan.Turbo
  alias Handan.Finance.Projections.PaymentEntry

  def get_payment_entry(payment_entry_uuid), do: Turbo.get(PaymentEntry, payment_entry_uuid)
end
