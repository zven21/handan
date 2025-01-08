defmodule Handan.Production.Projections.ProductionPlan do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "production_plans" do
    field :title, :string
    field :start_date, :date
    field :end_date, :date
    field :status, :string

    has_many :items, Handan.Production.Projections.ProductionPlanItem, foreign_key: :production_plan_uuid

    timestamps(type: :utc_datetime)
  end
end
