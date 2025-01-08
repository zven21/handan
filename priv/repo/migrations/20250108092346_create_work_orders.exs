defmodule Handan.Repo.Migrations.CreateWorkOrders do
  use Ecto.Migration

  def change do
    create table(:work_orders, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :production_plan_item_uuid, :binary_id
      add :status, :string
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create index(:work_orders, [:production_plan_item_uuid])
  end
end
