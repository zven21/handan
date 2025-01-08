defmodule Handan.Repo.Migrations.CreateProductionPlanItems do
  use Ecto.Migration

  def change do
    create table(:production_plan_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :production_plan_uuid, :string
      add :item_uuid, :string
      add :item_name, :string
      add :planned_qty, :decimal
      add :started_at, :naive_datetime
      add :ended_at, :naive_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
