defmodule Handan.Production.Projections.Workstation do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "workstations" do
    field :admin_uuid, :string
    field :members, {:array, :map}, default: []
    field :name, :string

    timestamps(type: :utc_datetime)
  end
end
