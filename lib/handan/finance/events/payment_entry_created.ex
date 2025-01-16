defmodule Handan.Finance.Events.PaymentEntryCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :payment_entry_uuid, Ecto.UUID
    field :party_type, Ecto.Enum, values: ~w(customer supplier)a
    field :party_uuid, Ecto.UUID
    field :payment_method_uuid, Ecto.UUID
    field :payment_method_name, :string
    field :memo, :string
    field :code, :string
    field :type, Ecto.Enum, values: ~w(sales_invoice purchase_invoice other)a
    field :attachments, {:array, :string}
    field :party_name, :string
    field :purchase_invoice_ids, {:array, Ecto.UUID}
    field :sales_invoice_ids, {:array, Ecto.UUID}
    field :total_amount, :decimal
  end
end
