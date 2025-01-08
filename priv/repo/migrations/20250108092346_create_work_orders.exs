defmodule Handan.Repo.Migrations.CreateWorkOrders do
  use Ecto.Migration

  def change do
    create table(:work_orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :production_plan_item_uuid, :string
      add :status, :string
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
