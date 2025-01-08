defmodule Handan.Production.JobCard do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "job_cards" do
    field :defective_qty, :decimal
    field :end_time, :string
    field :production_qty, :decimal
    field :start_time, :string
    field :status, :string
    field :work_order_item_uuid, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(job_card, attrs) do
    job_card
    |> cast(attrs, [:work_order_item_uuid, :status, :start_time, :end_time, :production_qty, :defective_qty])
    |> validate_required([:work_order_item_uuid, :status, :start_time, :end_time, :production_qty, :defective_qty])
  end
end
