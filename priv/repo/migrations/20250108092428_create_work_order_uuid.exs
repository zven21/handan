defmodule Handan.Repo.Migrations.CreateWorkOrderUuid do
  use Ecto.Migration

  def change do
    create table(:work_order_uuid, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :process_uuid, :string
      add :item_uuid, :string
      add :item_name, :string
      add :process_name, :string
      add :required_qty, :decimal
      add :returned_qty, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
