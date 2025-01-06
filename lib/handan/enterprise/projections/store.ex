defmodule Handan.Enterprise.Projections.Store do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "stores" do
    field :name, :string
    field :description, :string

    has_many :warehouses, Handan.Enterprise.Projections.Warehouse, foreign_key: :store_uuid
    has_many :uoms, Handan.Enterprise.Projections.UOM, foreign_key: :store_uuid

    timestamps(type: :utc_datetime)
  end
end
