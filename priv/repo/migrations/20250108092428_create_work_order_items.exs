defmodule Handan.Repo.Migrations.CreateWorkOrderItems do
  use Ecto.Migration

  def change do
    create table(:work_order_items, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :process_uuid, :binary_id
      add :position, :integer, default: 0
      add :item_uuid, :binary_id
      add :item_name, :string
      add :process_name, :string
      add :required_qty, :decimal
      add :produced_qty, :decimal
      add :defective_qty, :decimal
      add :work_order_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:work_order_items, [:process_uuid])
    create index(:work_order_items, [:item_uuid])
    create index(:work_order_items, [:work_order_uuid])
  end
end
