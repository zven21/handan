defmodule Handan.Repo.Migrations.CreatePaymentEntries do
  use Ecto.Migration

  def change do
    create table(:payment_entries, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :party_uuid, :binary_id
      add :party_type, :string
      add :party_name, :string
      add :sales_invoice_ids, {:array, :string}
      add :purchase_invoice_ids, {:array, :string}
      add :total_amount, :decimal
      add :payment_method_uuid, :binary_id
      add :memo, :string
      add :attachments, {:array, :string}, default: []

      timestamps(type: :utc_datetime)
    end

    create index(:payment_entries, [:party_uuid, :party_type])
    create index(:payment_entries, [:payment_method_uuid])
  end
end
