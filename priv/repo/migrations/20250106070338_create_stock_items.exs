defmodule Handan.Repo.Migrations.CreateStockItems do
  use Ecto.Migration

  def change do
    create table(:stock_items, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :item_uuid, :binary_id
      add :total_on_hand, :decimal
      add :warehouse_uuid, :binary_id
      add :stock_uom_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:stock_items, [:item_uuid, :stock_uom_uuid])
    create index(:stock_items, [:warehouse_uuid])
  end
end
