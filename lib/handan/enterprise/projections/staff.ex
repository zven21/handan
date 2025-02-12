defmodule Handan.Enterprise.Projections.Staff do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "staff" do
    field :name, :string
    field :email, :string

    belongs_to :user, Handan.Accounts.Projections.User, references: :uuid, foreign_key: :user_uuid
    belongs_to :company, Handan.Enterprise.Projections.Company, references: :uuid, foreign_key: :company_uuid

    timestamps(type: :utc_datetime)
  end
end
