defmodule Handan.Repo.Migrations.CreateSalesOrderItems do
  use Ecto.Migration

  def change do
    create table(:sales_order_items, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :item_name, :string
      add :unit_price, :decimal, default: 0
      add :amount, :decimal, default: 0
      add :ordered_qty, :decimal, default: 0
      add :delivered_qty, :decimal, default: 0
      add :remaining_qty, :decimal, default: 0

      add :item_uuid, :binary_id
      add :sales_order_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:sales_order_items, [:item_uuid])
    create index(:sales_order_items, [:sales_order_uuid])
  end
end
