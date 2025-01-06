defmodule Handan.Selling.Projections.Customer do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "customers" do
    field :name, :string
    field :address, :string
    field :balance, :decimal, default: 0

    belongs_to :store, Handan.Store.Projections.Store, foreign_key: :store_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
