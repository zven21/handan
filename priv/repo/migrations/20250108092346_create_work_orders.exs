defmodule Handan.Repo.Migrations.CreateWorkOrders do
  use Ecto.Migration

  def change do
    create table(:work_orders, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :type, :string
      add :status, :string
      add :planned_qty, :decimal, default: 0
      add :stored_qty, :decimal, default: 0
      add :produced_qty, :decimal, default: 0
      add :scraped_qty, :decimal, default: 0
      add :item_name, :string
      add :item_uuid, :binary_id
      add :stock_uom_uuid, :binary_id
      add :stock_uom_name, :string
      add :warehouse_uuid, :binary_id
      add :bom_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:work_orders, [:item_uuid])
    create index(:work_orders, [:stock_uom_uuid])
    create index(:work_orders, [:warehouse_uuid])
    create index(:work_orders, [:bom_uuid])
    create index(:work_orders, [:status])
  end
end
