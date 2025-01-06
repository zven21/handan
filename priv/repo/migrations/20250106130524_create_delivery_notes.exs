defmodule Handan.Repo.Migrations.CreateDeliveryNotes do
  use Ecto.Migration

  def change do
    create table(:delivery_notes, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :total_qty, :decimal
      add :sales_order_uuid, :binary_id
      add :customer_uuid, :binary_id
      add :customer_name, :string

      timestamps(type: :utc_datetime)
    end

    create index(:delivery_notes, [:customer_uuid])
    create index(:delivery_notes, [:sales_order_uuid])
  end
end
