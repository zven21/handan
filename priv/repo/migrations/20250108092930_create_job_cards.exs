defmodule Handan.Repo.Migrations.CreateJobCards do
  use Ecto.Migration

  def change do
    create table(:job_cards, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :work_order_item_uuid, :binary_id
      add :status, :string
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :produced_qty, :decimal, default: 0
      add :defective_qty, :decimal, default: 0
      add :operator_staff_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:job_cards, [:work_order_item_uuid])
  end
end
