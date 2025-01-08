defmodule Handan.Production.Projections.BOMItem do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bom_items" do
    field :item_name, :string
    field :qty, :integer, default: 0

    belongs_to :bom, Handan.Production.Projections.BOM, foreign_key: :bom_uuid, references: :uuid
    belongs_to :item, Handan.Stock.Projections.Item, foreign_key: :item_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
