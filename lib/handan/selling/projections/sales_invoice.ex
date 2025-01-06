defmodule Handan.Selling.Projections.SalesInvoice do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sales_invoices" do
    field :customer_name, :string
    field :customer_uuid, :string
    field :sales_order_uuid, :string
    field :status, :string
    field :total_amount, :decimal

    timestamps(type: :utc_datetime)
  end
end
