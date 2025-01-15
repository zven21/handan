defmodule Handan.Production.Projections.WorkOrderItem do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "work_order_items" do
    field :item_name, :string
    field :process_name, :string
    field :position, :integer
    field :required_qty, :decimal, default: 0
    field :defective_qty, :decimal, default: 0
    field :produced_qty, :decimal, default: 0

    belongs_to :work_order, Handan.Production.Projections.WorkOrder, foreign_key: :work_order_uuid, references: :uuid
    belongs_to :process, Handan.Production.Projections.Process, foreign_key: :process_uuid, references: :uuid
    belongs_to :item, Handan.Stock.Projections.Item, foreign_key: :item_uuid, references: :uuid

    # has_many :material_requests, Handan.Production.Projections.MaterialRequest, foreign_key: :work_order_item_uuid, references: :uuid
    has_many :job_cards, Handan.Production.Projections.JobCard, foreign_key: :work_order_item_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
