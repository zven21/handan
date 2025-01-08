defmodule Handan.Repo.Migrations.CreateSuppliers do
  use Ecto.Migration

  def change do
    create table(:suppliers, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :name, :string
      add :address, :string

      timestamps(type: :utc_datetime)
    end
  end
end
