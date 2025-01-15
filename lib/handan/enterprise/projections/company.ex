defmodule Handan.Enterprise.Projections.Company do
  @moduledoc """
  Projection for company.
  Represents the meaning of small and medium-sized enterprises, this is the basic information configuration of the enterprise.
  """

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "companies" do
    field :name, :string
    field :description, :string
    field :owner_uuid, Ecto.UUID

    has_many :staff, Handan.Enterprise.Projections.Staff, foreign_key: :company_uuid

    timestamps(type: :utc_datetime)
  end
end
