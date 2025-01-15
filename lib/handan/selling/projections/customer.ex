defmodule Handan.Selling.Projections.Customer do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "customers" do
    field :name, :string
    field :address, :string
    field :balance, :decimal, default: 0

    timestamps(type: :utc_datetime)
  end
end
