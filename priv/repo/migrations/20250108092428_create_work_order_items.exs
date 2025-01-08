defmodule Handan.Repo.Migrations.CreateWorkOrderItems do
  use Ecto.Migration

  def change do
    create table(:work_order_items, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :process_uuid, :binary_id
      add :item_uuid, :binary_id
      add :item_name, :string
      add :process_name, :string
      add :required_qty, :decimal
      add :returned_qty, :decimal

      timestamps(type: :utc_datetime)
    end

    create index(:work_order_items, [:process_uuid])
    create index(:work_order_items, [:item_uuid])
  end
end
