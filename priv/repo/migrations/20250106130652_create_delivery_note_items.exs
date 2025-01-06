defmodule Handan.Repo.Migrations.CreateDeliveryNoteItems do
  use Ecto.Migration

  def change do
    create table(:delivery_note_items, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :delivery_note_uuid, :binary_id
      add :sales_order_uuid, :binary_id
      add :sales_order_item_uuid, :binary_id
      add :qty, :decimal
      add :item_uuid, :binary_id
      add :item_name, :string

      timestamps(type: :utc_datetime)
    end

    create index(:delivery_note_items, [:delivery_note_uuid])
    create index(:delivery_note_items, [:sales_order_uuid])
    create index(:delivery_note_items, [:sales_order_item_uuid])
  end
end
