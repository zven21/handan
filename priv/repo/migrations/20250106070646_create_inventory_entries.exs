defmodule Handan.Repo.Migrations.CreateInventoryEntries do
  use Ecto.Migration

  def change do
    create table(:inventory_entries, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :item_uuid, :binary_id
      add :type, :string
      add :warehouse_uuid, :binary_id
      add :stock_uom_uuid, :binary_id
      add :actual_qty, :decimal
      add :qty_after_transaction, :decimal
      add :thread_uuid, :binary_id
      add :thread_type, :string

      timestamps(type: :utc_datetime)
    end

    create index(:inventory_entries, [:item_uuid])
    create index(:inventory_entries, [:warehouse_uuid])
    create index(:inventory_entries, [:stock_uom_uuid])
    create index(:inventory_entries, [:thread_uuid, :thread_type])
  end
end
