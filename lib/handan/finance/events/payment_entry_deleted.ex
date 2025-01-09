defmodule Handan.Finance.Events.PaymentEntryDeleted do
  @moduledoc false
  use Handan.EventSourcing.Event

  defevent do
    field :payment_entry_uuid, Ecto.UUID
  end
end
