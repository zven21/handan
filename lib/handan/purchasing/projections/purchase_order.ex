defmodule Handan.Purchasing.Projections.PurchaseOrder do
  @moduledoc """
  Purchase Order
  """

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "purchase_orders" do
    field :status, Ecto.Enum, values: ~w(draft to_receive to_bill to_receive_and_bill completed cancelled)a, default: :draft
    field :receipt_status, Ecto.Enum, values: ~w(not_received partly_received fully_received closed)a, default: :not_received
    field :billing_status, Ecto.Enum, values: ~w(not_billed partly_billed fully_billed closed)a, default: :not_billed

    field :supplier_name, :string
    field :supplier_address, :string

    field :total_amount, :decimal
    field :paid_amount, :decimal
    field :remaining_amount, :decimal

    field :total_qty, :decimal
    field :received_qty, :decimal
    field :remaining_qty, :decimal

    belongs_to :supplier, Handan.Purchasing.Projections.Supplier, foreign_key: :supplier_uuid, references: :uuid
    belongs_to :warehouse, Handan.Enterprise.Projections.Warehouse, foreign_key: :warehouse_uuid, references: :uuid

    has_many :items, Handan.Purchasing.Projections.PurchaseOrderItem, foreign_key: :purchase_order_uuid, references: :uuid
    has_many :purchase_invoices, Handan.Purchasing.Projections.PurchaseInvoice, foreign_key: :purchase_order_uuid, references: :uuid
    has_many :receipt_notes, Handan.Purchasing.Projections.ReceiptNote, foreign_key: :purchase_order_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
