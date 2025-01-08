defmodule Handan.Repo.Migrations.CreateProductionPlanItems do
  use Ecto.Migration

  def change do
    create table(:production_plan_items, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :production_plan_uuid, :binary_id
      add :item_uuid, :binary_id
      add :item_name, :string

      add :planned_qty, :decimal, default: 0

      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create index(:production_plan_items, [:production_plan_uuid])
    create index(:production_plan_items, [:item_uuid])
  end
end
