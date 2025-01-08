defmodule Handan.Repo.Migrations.CreatePurchaseInvoices do
  use Ecto.Migration

  def change do
    create table(:purchase_invoices, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :amount, :decimal
      add :status, :string
      add :supplier_name, :string
      add :purchase_order_uuid, :binary_id
      add :supplier_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:purchase_invoices, [:purchase_order_uuid])
    create index(:purchase_invoices, [:supplier_uuid])
  end
end
