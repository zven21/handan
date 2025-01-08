defmodule Handan.Repo.Migrations.CreateProductionPlans do
  use Ecto.Migration

  def change do
    create table(:production_plans, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :title, :string
      add :status, :string
      add :start_date, :date
      add :end_date, :date

      timestamps(type: :utc_datetime)
    end
  end
end
