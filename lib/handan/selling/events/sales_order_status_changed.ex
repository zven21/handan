defmodule Handan.Selling.Events.SalesOrderStatusChanged do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :sales_order_uuid, Ecto.UUID

    field :from_status, :string
    field :to_status, :string

    field :from_delivery_status, :string
    field :to_delivery_status, :string

    field :from_billing_status, :string
    field :to_billing_status, :string
  end
end
