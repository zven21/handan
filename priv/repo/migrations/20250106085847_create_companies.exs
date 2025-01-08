defmodule Handan.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :owner_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:companies, [:owner_uuid])
  end
end
