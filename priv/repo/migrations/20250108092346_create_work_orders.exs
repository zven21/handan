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
      add :item_name, :string
      add :item_uuid, references(:items, type: :binary_id)
      add :stock_uom_uuid, references(:stock_uoms, type: :binary_id)
      add :stock_uom_name, :string
      add :warehouse_uuid, references(:warehouses, type: :binary_id)
      add :bom_uuid, references(:boms, type: :binary_id)

      timestamps(type: :utc_datetime)
    end
  end
end
