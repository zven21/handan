defmodule Handan.Selling.Projections.DeliveryNote do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "delivery_notes" do
    field :customer_name, :string
    field :customer_uuid, :string
    field :sales_order_uuid, :string
    field :total_qty, :decimal

    timestamps(type: :utc_datetime)
  end
end
