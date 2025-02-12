defmodule Handan.Production.Projections.JobCard do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "job_cards" do
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :status, :string
    field :defective_qty, :decimal, default: 0
    field :produced_qty, :decimal, default: 0

    belongs_to :work_order_item, Handan.Production.Projections.WorkOrderItem, foreign_key: :work_order_item_uuid, references: :uuid
    # belongs_to :work_order, Handan.Production.Projections.WorkOrder, foreign_key: :work_order_uuid, references: :uuid
    belongs_to :operator_staff, Handan.Enterprise.Projections.Staff, foreign_key: :operator_staff_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
