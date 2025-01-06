defmodule Handan.Stock.Projections.Warehouse do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "warehouses" do
    field :address, :string
    field :area, :string
    field :contact_mobile, :string
    field :contact_name, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end
end
