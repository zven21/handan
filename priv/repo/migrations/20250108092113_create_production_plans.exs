defmodule Handan.Repo.Migrations.CreateProductionPlans do
  use Ecto.Migration

  def change do
    create table(:production_plans, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :start_date, :string
      add :end_date, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
