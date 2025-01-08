defmodule Handan.Purchasing.Projections.Supplier do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "suppliers" do
    field :address, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end
end
