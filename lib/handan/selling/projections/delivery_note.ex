defmodule Handan.Selling.Projections.DeliveryNote do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "delivery_notes" do
    field :code, :string
    field :customer_name, :string
    field :status, Ecto.Enum, values: ~w(draft to_deliver completed cancelled)a, default: :draft
    field :total_qty, :decimal, default: 0
    field :total_amount, :decimal, default: 0

    belongs_to :sales_order, Handan.Selling.Projections.SalesOrder, foreign_key: :sales_order_uuid, references: :uuid
    belongs_to :customer, Handan.Selling.Projections.Customer, foreign_key: :customer_uuid, references: :uuid
    belongs_to :warehouse, Handan.Enterprise.Projections.Warehouse, foreign_key: :warehouse_uuid, references: :uuid

    has_many :items, Handan.Selling.Projections.DeliveryNoteItem, foreign_key: :delivery_note_uuid

    timestamps(type: :utc_datetime)
  end
end
