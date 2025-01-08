defmodule Handan.Repo.Migrations.CreateMaterialRequestItems do
  use Ecto.Migration

  def change do
    create table(:material_request_items, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :actual_qty, :decimal
      add :bom_uuid, :binary_id
      add :item_uuid, :binary_id
      add :item_name, :string
      add :stock_uom_uuid, :binary_id
      add :uom_name, :string
      add :material_request_uuid, :binary_id

      add :from_warehouse_uuid, :binary_id
      add :to_warehouse_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:material_request_items, [:bom_uuid])
    create index(:material_request_items, [:item_uuid])
    create index(:material_request_items, [:material_request_uuid])
    create index(:material_request_items, [:stock_uom_uuid])
    create index(:material_request_items, [:from_warehouse_uuid])
    create index(:material_request_items, [:to_warehouse_uuid])
  end
end
