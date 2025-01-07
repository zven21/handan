defmodule Handan.Selling.Projections.SalesOrder do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sales_orders" do
    field :customer_name, :string

    field :billing_status, Ecto.Enum, values: ~w(not_billed fully_billed partly_billed closed)a, default: :not_billed
    field :delivery_status, Ecto.Enum, values: ~w(not_delivered fully_delivered partly_delivered closed)a, default: :not_delivered
    field :status, Ecto.Enum, values: ~w(draft to_deliver_and_bill to_bill to_deliver completed cancelled)a, default: :draft

    field :total_amount, :decimal, default: 0
    field :total_qty, :decimal, default: 0

    belongs_to :warehouse, Handan.Enterprise.Projections.Warehouse, foreign_key: :warehouse_uuid, references: :uuid
    belongs_to :customer, Handan.Selling.Projections.Customer, foreign_key: :customer_uuid, references: :uuid

    has_many :items, Handan.Selling.Projections.SalesOrderItem, foreign_key: :sales_order_uuid

    timestamps(type: :utc_datetime)
  end
end
