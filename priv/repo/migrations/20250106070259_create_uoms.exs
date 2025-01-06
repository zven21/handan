defmodule Handan.Repo.Migrations.CreateUoms do
  use Ecto.Migration

  def change do
    create table(:uoms, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :name, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
