defmodule Handan.Enterprise.Projections.UOM do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "uoms" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end
end
