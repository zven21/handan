defmodule Handan.Purchasing.Projections.PurchaseOrder do
  @moduledoc """
  Purchase Order
  """

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "purchase_orders" do
    field :status, :string
    field :receipt_status, :string
    field :billing_status, :string

    field :supplier_name, :string
    field :supplier_address, :string

    field :total_amount, :decimal
    field :total_qty, :decimal

    belongs_to :supplier, Handan.Purchasing.Projections.Supplier, foreign_key: :supplier_uuid, references: :uuid
    belongs_to :warehouse, Handan.Enterprise.Projections.Warehouse, foreign_key: :warehouse_uuid, references: :uuid

    has_many :items, Handan.Purchasing.Projections.PurchaseOrderItem, foreign_key: :purchase_order_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
