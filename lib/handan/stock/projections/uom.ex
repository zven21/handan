defmodule Handan.Stock.Projections.UOM do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "uoms" do
    field :description, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end
end
