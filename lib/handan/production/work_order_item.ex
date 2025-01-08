defmodule Handan.Production.WorkOrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "work_order_uuid" do
    field :item_name, :string
    field :item_uuid, :string
    field :process_name, :string
    field :process_uuid, :string
    field :required_qty, :decimal
    field :returned_qty, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(work_order_item, attrs) do
    work_order_item
    |> cast(attrs, [:process_uuid, :item_uuid, :item_name, :process_name, :required_qty, :returned_qty])
    |> validate_required([:process_uuid, :item_uuid, :item_name, :process_name, :required_qty, :returned_qty])
  end
end
