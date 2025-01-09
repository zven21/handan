defmodule Handan.Production.Projections.MaterialRequest do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "material_requests" do
    field :title, :string
    field :status, :string
    field :production_plan_uuid, Ecto.UUID

    # belongs_to :production_plan, Handan.Production.Projections.ProductionPlan, foreign_key: :production_plan_uuid, references: :uuid

    belongs_to :work_order, Handan.Production.Projections.WorkOrder, foreign_key: :work_order_uuid, references: :uuid

    has_many :items, Handan.Production.Projections.MaterialRequestItem, foreign_key: :material_request_uuid

    timestamps(type: :utc_datetime)
  end
end
