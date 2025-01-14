defmodule Handan.Repo.Migrations.CreateDeliveryNotes do
  use Ecto.Migration

  def change do
    create table(:delivery_notes, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :total_qty, :decimal
      add :total_amount, :decimal
      add :status, :string
      add :sales_order_uuid, :binary_id
      add :customer_uuid, :binary_id
      add :customer_name, :string
      add :warehouse_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:delivery_notes, [:customer_uuid])
    create index(:delivery_notes, [:sales_order_uuid])
    create index(:delivery_notes, [:warehouse_uuid])
  end
end
