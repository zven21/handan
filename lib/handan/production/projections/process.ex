defmodule Handan.Production.Projections.Process do
  @moduledoc """
  Process
  """

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "processes" do
    field :code, :string
    field :description, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end
end
