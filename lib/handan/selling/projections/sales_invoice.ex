defmodule Handan.Selling.Projections.SalesInvoice do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sales_invoices" do
    field :customer_name, :string
    field :amount, :decimal

    field :status, Ecto.Enum, values: ~w(draft submitted paid cancelled)a, default: :draft

    belongs_to :sales_order, Handan.Selling.Projections.SalesOrder, foreign_key: :sales_order_uuid, references: :uuid
    belongs_to :customer, Handan.Selling.Projections.Customer, foreign_key: :customer_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
