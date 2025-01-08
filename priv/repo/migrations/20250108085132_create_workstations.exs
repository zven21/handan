defmodule Handan.Repo.Migrations.CreateWorkstations do
  use Ecto.Migration

  def change do
    create table(:workstations, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :name, :string
      add :admin_uuid, :string
      add :members, {:array, :map}, default: []

      timestamps(type: :utc_datetime)
    end
  end
end
