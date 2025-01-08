defmodule Handan.Production.Projections.ProductionPlanItem do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "production_plan_items" do
    field :item_name, :string
    field :planned_qty, :decimal, default: 0

    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    belongs_to :production_plan, Handan.Production.Projections.ProductionPlan, foreign_key: :production_plan_uuid, references: :uuid
    belongs_to :item, Handan.Stock.Projections.Item, foreign_key: :item_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
