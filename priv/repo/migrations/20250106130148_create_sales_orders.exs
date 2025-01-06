defmodule Handan.Repo.Migrations.CreateSalesOrders do
  use Ecto.Migration

  def change do
    create table(:sales_orders, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :customer_uuid, :binary_id
      add :customer_name, :string
      add :delivery_status, :string
      add :billing_status, :string
      add :status, :string
      add :total_qty, :decimal
      add :total_amount, :decimal
      add :warehouse_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:sales_orders, [:customer_uuid])
  end
end
