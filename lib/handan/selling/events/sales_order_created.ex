defmodule Handan.Selling.Events.SalesOrderCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :sales_order_uuid, Ecto.UUID
    field :code, :string

    # customer
    field :customer_uuid, Ecto.UUID
    field :customer_name, :string
    field :customer_address, :string

    # 金额
    field :paid_amount, :decimal
    field :total_amount, :decimal
    field :remaining_amount, :decimal

    # 数量
    field :total_qty, :decimal
    field :delivered_qty, :decimal
    field :remaining_qty, :decimal

    # status
    field :status, :string
    field :delivery_status, :string
    field :billing_status, :string

    field :warehouse_uuid, Ecto.UUID
    field :warehouse_name, :string
  end
end
