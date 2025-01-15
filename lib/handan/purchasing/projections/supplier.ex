defmodule Handan.Purchasing.Projections.Supplier do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "suppliers" do
    field :name, :string
    field :address, :string
    field :balance, :decimal, default: 0

    timestamps(type: :utc_datetime)
  end
end
