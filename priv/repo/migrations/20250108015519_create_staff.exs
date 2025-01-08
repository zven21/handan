defmodule Handan.Repo.Migrations.CreateStaff do
  use Ecto.Migration

  def change do
    create table(:staff, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :name, :string
      add :mobile, :string

      add :user_uuid, :binary_id
      add :company_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create unique_index(:staff, [:user_uuid, :company_uuid])
  end
end
