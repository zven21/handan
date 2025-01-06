defmodule Handan.Selling.Projections.SalesOrderItem do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sales_order_items" do
    field :item_name, :string
    field :unit_price, :decimal
    field :amount, :decimal
    field :ordered_qty, :decimal
    field :delivered_qty, :decimal
    field :remaining_qty, :decimal

    belongs_to :sales_order, Handan.Selling.Projections.SalesOrder, foreign_key: :sales_order_uuid, references: :uuid
    belongs_to :item, Handan.Inventory.Projections.Item, foreign_key: :item_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
