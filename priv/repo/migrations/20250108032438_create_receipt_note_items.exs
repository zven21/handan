defmodule Handan.Repo.Migrations.CreateReceiptNoteItems do
  use Ecto.Migration

  def change do
    create table(:receipt_note_items, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :item_uuid, :binary_id
      add :item_name, :string
      add :receipt_note_uuid, :binary_id
      add :stock_uom_uuid, :binary_id
      add :uom_name, :string
      add :amount, :decimal
      add :unit_price, :decimal
      add :actual_qty, :decimal, default: 0
      add :purchase_order_item_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:receipt_note_items, [:receipt_note_uuid])
    create index(:receipt_note_items, [:item_uuid])
    create index(:receipt_note_items, [:stock_uom_uuid])
    create index(:receipt_note_items, [:purchase_order_item_uuid])
  end
end
