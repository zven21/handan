defmodule Handan.Selling.Projections.DeliveryNoteItem do
  @moduledoc false
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "delivery_note_items" do
    field :item_name, :string
    field :qty, :decimal

    field :item_uuid, :string
    field :delivery_note_uuid, :binary_id
    field :sales_order_uuid, :binary_id
    field :sales_order_item_uuid, :binary_id

    timestamps(type: :utc_datetime)
  end
end
