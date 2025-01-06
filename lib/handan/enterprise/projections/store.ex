defmodule Handan.Enterprise.Projections.Store do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "stores" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end
end
