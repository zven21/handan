defmodule Handan.Enterprise.Projections.Warehouse do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "warehouses" do
    field :name, :string
    field :address, :string
    field :area, :string
    field :contact_email, :string
    field :contact_name, :string
    field :is_default, :boolean, default: false

    timestamps(type: :utc_datetime)
  end
end
