defmodule Handan.Enterprise.Projections.Company do
  @moduledoc """
  Projection for company.
  Represents the meaning of small and medium-sized enterprises, this is the basic information configuration of the enterprise.
  """

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "companies" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end
end
