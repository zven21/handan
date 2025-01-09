defmodule Handan.Repo.Migrations.CreateMaterialRequests do
  use Ecto.Migration

  def change do
    create table(:material_requests, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :status, :string
      add :title, :string
      # add :production_plan_uuid, :binary_id
      add :work_order_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    # create index(:material_requests, [:production_plan_uuid])
    create index(:material_requests, [:work_order_uuid])
  end
end
