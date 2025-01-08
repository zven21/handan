defmodule Handan.Purchasing.Aggregates.PurchaseOrder do
  @moduledoc """
  停止已删除的聚合
  """
  @required_fields []

  use Handan.EventSourcing.Type
  import Handan.Infrastructure.DecimalHelper, only: [decimal_add: 2, decimal_sub: 2]

  alias Decimal, as: D

  deftype do
    field :purchase_order_uuid, Ecto.UUID
    field :supplier_uuid, Ecto.UUID
    field :supplier_name, :string
    field :supplier_address, :string
    field :warehouse_uuid, Ecto.UUID

    field :total_amount, :decimal
    field :paid_amount, :decimal, default: 0
    field :remaining_amount, :decimal, default: 0

    field :total_qty, :decimal
    field :received_qty, :decimal, default: 0
    field :remaining_qty, :decimal, default: 0

    field :receipt_status, :string
    field :billing_status, :string
    field :status, :string

    # 采购订单项
    field :purchase_items, :map, default: %{}

    # 收货单
    field :receipt_notes, :map, default: %{}
    field :receipt_note_items, :map, default: %{}

    # 采购发票
    field :purchase_invoices, :map, default: %{}

    field :deleted?, :boolean, default: false
  end
end
