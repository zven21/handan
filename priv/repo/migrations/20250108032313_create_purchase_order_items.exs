defmodule Handan.Repo.Migrations.CreatePurchaseOrderItems do
  use Ecto.Migration

  def change do
    create table(:purchase_order_items, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :item_name, :string
      add :unit_price, :decimal
      add :amount, :decimal
      add :uom_name, :string
      add :ordered_qty, :decimal, default: 0
      add :received_qty, :decimal, default: 0
      add :remaining_qty, :decimal, default: 0

      add :purchase_order_uuid, :binary_id
      add :item_uuid, :binary_id
      add :stock_uom_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:purchase_order_items, [:purchase_order_uuid])
    create index(:purchase_order_items, [:item_uuid])
    create index(:purchase_order_items, [:stock_uom_uuid])
  end
end
