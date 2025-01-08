defmodule Handan.Production.ProductionPlan do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "production_plans" do
    field :end_date, :string
    field :start_date, :string
    field :status, :string
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(production_plan, attrs) do
    production_plan
    |> cast(attrs, [:title, :start_date, :end_date, :status])
    |> validate_required([:title, :start_date, :end_date, :status])
  end
end
