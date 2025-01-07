defmodule Handan.Repo.Migrations.CreateDeliveryNoteItems do
  use Ecto.Migration

  def change do
    create table(:delivery_note_items, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :delivery_note_uuid, :binary_id
      add :sales_order_uuid, :binary_id
      add :sales_order_item_uuid, :binary_id
      add :item_uuid, :binary_id
      add :item_name, :string

      add :uom_name, :string
      add :stock_uom_uuid, :binary_id

      add :actual_qty, :decimal
      add :amount, :decimal
      add :unit_price, :decimal

      timestamps(type: :utc_datetime)
    end

    create index(:delivery_note_items, [:delivery_note_uuid])
    create index(:delivery_note_items, [:sales_order_uuid])
    create index(:delivery_note_items, [:sales_order_item_uuid])
    create index(:delivery_note_items, [:item_uuid])
  end
end
