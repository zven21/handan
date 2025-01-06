defmodule Handan.Enterprise.Projections.Warehouse do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "warehouses" do
    field :address, :string
    field :area, :string
    field :contact_mobile, :string
    field :contact_name, :string
    field :name, :string
    field :is_default, :boolean, default: false

    belongs_to :store, Handan.Enterprise.Projections.Store, references: :uuid, foreign_key: :store_uuid

    timestamps(type: :utc_datetime)
  end
end
