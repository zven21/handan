defmodule Handan.Production.Projections.BOM do
  @moduledoc """
  Bill of Materials
  """

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "boms" do
    field :name, :string
    field :item_name, :string

    belongs_to :item, Handan.Stock.Projections.Item, foreign_key: :item_uuid, references: :uuid

    has_many :bom_items, Handan.Production.Projections.BOMItem, foreign_key: :bom_uuid, references: :uuid
    has_many :bom_processes, Handan.Production.Projections.BOMProcess, foreign_key: :bom_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
