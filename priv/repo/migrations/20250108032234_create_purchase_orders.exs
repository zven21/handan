defmodule Handan.Repo.Migrations.CreatePurchaseOrders do
  use Ecto.Migration

  def change do
    create table(:purchase_orders, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :receipt_status, :string
      add :status, :string
      add :billing_status, :string

      add :supplier_name, :string
      add :supplier_address, :string

      add :total_amount, :decimal
      add :total_qty, :decimal

      add :supplier_uuid, :binary_id
      add :warehouse_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:purchase_orders, [:supplier_uuid])
    create index(:purchase_orders, [:warehouse_uuid])
    create index(:purchase_orders, [:receipt_status])
    create index(:purchase_orders, [:status])
    create index(:purchase_orders, [:billing_status])
  end
end
