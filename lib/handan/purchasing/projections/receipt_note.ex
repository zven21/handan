defmodule Handan.Purchasing.Projections.ReceiptNote do
  @moduledoc """
  Receipt Note
  """

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "receipt_notes" do
    field :code, :string
    field :supplier_name, :string
    field :total_amount, :decimal
    field :total_qty, :decimal
    field :status, Ecto.Enum, values: [:draft, :to_receive, :completed], default: :draft

    belongs_to :purchase_order, Handan.Purchasing.Projections.PurchaseOrder, foreign_key: :purchase_order_uuid, references: :uuid
    belongs_to :supplier, Handan.Purchasing.Projections.Supplier, foreign_key: :supplier_uuid, references: :uuid
    belongs_to :warehouse, Handan.Enterprise.Projections.Warehouse, foreign_key: :warehouse_uuid, references: :uuid

    has_many :items, Handan.Purchasing.Projections.ReceiptNoteItem, foreign_key: :receipt_note_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
