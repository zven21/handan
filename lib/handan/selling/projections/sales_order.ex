defmodule Handan.Selling.Projections.SalesOrder do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sales_orders" do
    field :customer_name, :string
    field :billing_status, :string
    field :delivery_status, :string
    field :status, :string

    field :total_amount, :decimal, default: 0
    field :total_qty, :decimal, default: 0

    belongs_to :warehouse, Handan.Enterprise.Projections.Warehouse, foreign_key: :warehouse_uuid, references: :uuid
    belongs_to :customer, Handan.Selling.Projections.Customer, foreign_key: :customer_uuid, references: :uuid

    has_many :items, Handan.Selling.Projections.SalesOrderItem, foreign_key: :sales_order_uuid

    timestamps(type: :utc_datetime)
  end
end
