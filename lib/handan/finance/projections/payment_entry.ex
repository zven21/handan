defmodule Handan.Finance.Projections.PaymentEntry do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "payment_entries" do
    field :memo, :string
    field :attachments, {:array, :string}, default: []
    field :party_name, :string
    field :party_type, :string
    field :party_uuid, :binary_id
    field :purchase_invoice_ids, {:array, :string}, default: []
    field :sales_invoice_ids, {:array, :string}, default: []
    field :total_amount, :decimal

    belongs_to :payment_method, Handan.Finance.Projections.PaymentMethod, foreign_key: :payment_method_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
