defmodule Handan.Repo.Migrations.CreateWorkOrderMaterialRequests do
  use Ecto.Migration

  def change do
    create table(:work_order_material_requests, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :item_name, :string
      add :actual_qty, :decimal, default: 0.0
      add :remaining_qty, :decimal, default: 0.0
      add :received_qty, :decimal, default: 0.0
      add :uom_name, :string

      add :work_order_uuid, :binary_id
      add :item_uuid, :binary_id
      add :bom_uuid, :binary_id
      add :stock_uom_uuid, :binary_id
      add :warehouse_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:work_order_material_requests, [:work_order_uuid])
    create index(:work_order_material_requests, [:item_uuid])
    create index(:work_order_material_requests, [:bom_uuid])
    create index(:work_order_material_requests, [:stock_uom_uuid])
  end
end
