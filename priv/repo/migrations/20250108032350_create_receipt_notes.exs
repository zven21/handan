defmodule Handan.Repo.Migrations.CreateReceiptNotes do
  use Ecto.Migration

  def change do
    create table(:receipt_notes, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :code, :string
      add :purchase_order_uuid, :binary_id
      add :total_qty, :decimal
      add :total_amount, :decimal
      add :status, :string
      add :supplier_uuid, :binary_id
      add :supplier_name, :string
      add :warehouse_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create unique_index(:receipt_notes, [:code])
    create index(:receipt_notes, [:purchase_order_uuid])
    create index(:receipt_notes, [:supplier_uuid])
    create index(:receipt_notes, [:warehouse_uuid])
  end
end
