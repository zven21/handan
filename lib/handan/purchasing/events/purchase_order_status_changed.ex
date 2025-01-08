defmodule Handan.Purchasing.Events.PurchaseOrderStatusChanged do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :purchase_order_uuid, Ecto.UUID

    field :from_status, :string
    field :to_status, :string

    field :from_receipt_status, :string
    field :to_receipt_status, :string

    field :from_billing_status, :string
    field :to_billing_status, :string
  end
end
