defmodule Handan.Enterprise.Projections.UOM do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "uoms" do
    field :name, :string
    field :description, :string

    belongs_to :store, Handan.Enterprise.Projections.Store, references: :uuid, foreign_key: :store_uuid

    timestamps(type: :utc_datetime)
  end
end
