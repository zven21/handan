defmodule Handan.Production.Projections.WorkOrder do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "work_orders" do
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :status, :string

    belongs_to :production_plan_item, Handan.Production.Projections.ProductionPlanItem, foreign_key: :production_plan_item_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
