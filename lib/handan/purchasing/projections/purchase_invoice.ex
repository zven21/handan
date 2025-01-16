defmodule Handan.Purchasing.Projections.PurchaseInvoice do
  @moduledoc """
  Purchase Invoice
  """

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "purchase_invoices" do
    field :code, :string
    field :amount, :decimal, default: 0
    field :status, Ecto.Enum, values: ~w(draft unpaid paid cancelled)a, default: :draft
    field :supplier_name, :string

    belongs_to :purchase_order, Handan.Purchasing.Projections.PurchaseOrder, foreign_key: :purchase_order_uuid, references: :uuid
    belongs_to :supplier, Handan.Purchasing.Projections.Supplier, foreign_key: :supplier_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
