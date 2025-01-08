defmodule Handan.Production.Projections.BOM do
  @moduledoc """
  Bill of Materials
  """

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "boms" do
    field :name, :string
    field :item_name, :string

    belongs_to :item, Handan.Stock.Projections.Item, foreign_key: :item_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
