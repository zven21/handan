defmodule Handan.Repo.Migrations.CreateJobCards do
  use Ecto.Migration

  def change do
    create table(:job_cards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :work_order_item_uuid, :string
      add :status, :string
      add :start_time, :string
      add :end_time, :string
      add :production_qty, :decimal
      add :defective_qty, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
