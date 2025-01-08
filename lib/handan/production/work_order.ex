defmodule Handan.Production.WorkOrder do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "work_orders" do
    field :end_time, :naive_datetime
    field :production_plan_item_uuid, :string
    field :start_time, :naive_datetime
    field :status, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(work_order, attrs) do
    work_order
    |> cast(attrs, [:production_plan_item_uuid, :status, :start_time, :end_time])
    |> validate_required([:production_plan_item_uuid, :status, :start_time, :end_time])
  end
end
