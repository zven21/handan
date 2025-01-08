defmodule Handan.Production.ProductionPlanItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "production_plan_items" do
    field :ended_at, :naive_datetime
    field :item_name, :string
    field :item_uuid, :string
    field :planned_qty, :decimal
    field :production_plan_uuid, :string
    field :started_at, :naive_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(production_plan_item, attrs) do
    production_plan_item
    |> cast(attrs, [:production_plan_uuid, :item_uuid, :item_name, :planned_qty, :started_at, :ended_at])
    |> validate_required([:production_plan_uuid, :item_uuid, :item_name, :planned_qty, :started_at, :ended_at])
  end
end
