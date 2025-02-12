defmodule Handan.Repo.Migrations.CreateSalesOrders do
  use Ecto.Migration

  def change do
    create table(:sales_orders, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :code, :string
      add :customer_uuid, :binary_id
      add :customer_name, :string
      add :delivery_status, :string
      add :billing_status, :string
      add :status, :string

      add :total_qty, :decimal
      add :delivered_qty, :decimal
      add :remaining_qty, :decimal

      add :total_amount, :decimal
      add :paid_amount, :decimal
      add :remaining_amount, :decimal

      add :warehouse_uuid, :binary_id
      add :warehouse_name, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:sales_orders, [:code])
    create index(:sales_orders, [:customer_uuid])
    create index(:sales_orders, [:status])
    create index(:sales_orders, [:warehouse_uuid])
  end
end
