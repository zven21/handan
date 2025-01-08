defmodule Handan.Production.Projections.BOMProcess do
  @moduledoc """
  Bill of Materials Process
  """

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bom_processes" do
    field :position, :integer
    field :process_name, :string
    field :tool_required, :string

    belongs_to :bom, Handan.Production.Projections.BOM, foreign_key: :bom_uuid, references: :uuid
    belongs_to :process, Handan.Production.Projections.Process, foreign_key: :process_uuid, references: :uuid
    # belongs_to :workstation, Handan.Production.Projections.Workstation, foreign_key: :workstation_uuid, references: :uuid

    timestamps(type: :utc_datetime)
  end
end
