defmodule Handan.Selling.Events.SalesOrderCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :sales_order_uuid, Ecto.UUID
    field :customer_uuid, Ecto.UUID
    field :customer_name, :string
    field :customer_address, :string
    field :store_uuid, Ecto.UUID
    field :total_amount, :decimal
    field :total_qty, :decimal
    field :status, :string
    field :delivery_status, :string
    field :billing_status, :string
  end
end
