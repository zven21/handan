defmodule Handan.Selling.Projections.SalesOrder do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sales_orders" do
    field :billing_status, :string
    field :customer_name, :string
    field :customer_uuid, :binary_id
    field :delivery_status, :string
    field :status, :string
    field :warehouse_uuid, :binary_id

    field :total_amount, :decimal
    field :total_qty, :decimal

    timestamps(type: :utc_datetime)
  end
end
