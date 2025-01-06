defmodule Handan.Stock.Productions.UOM do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "uoms" do
    field :description, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(uom, attrs) do
    uom
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
