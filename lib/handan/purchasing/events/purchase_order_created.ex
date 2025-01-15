defmodule Handan.Purchasing.Events.PurchaseOrderCreated do
  @moduledoc false

  use Handan.EventSourcing.Event

  defevent do
    field :purchase_order_uuid, Ecto.UUID
    field :code, :string

    # 供应商
    field :supplier_uuid, Ecto.UUID
    field :supplier_name, :string
    field :supplier_address, :string

    # 金额
    field :paid_amount, :decimal
    field :total_amount, :decimal
    field :remaining_amount, :decimal

    # 数量
    field :total_qty, :decimal
    field :received_qty, :decimal
    field :remaining_qty, :decimal

    # 状态
    field :status, :string
    field :receipt_status, :string
    field :billing_status, :string

    field :warehouse_uuid, Ecto.UUID
  end
end
