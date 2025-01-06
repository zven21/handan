defmodule Handan.Selling.Projections.SalesOrderItem do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sales_order_items" do
    field :amount, :decimal
    field :item_name, :string
    field :item_uuid, :string
    field :ordered_qty, :integer
    field :sales_order_uuid, :string
    field :unit_price, :decimal

    timestamps(type: :utc_datetime)
  end
end
