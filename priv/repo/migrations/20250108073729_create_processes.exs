defmodule Handan.Repo.Migrations.CreateProcesses do
  use Ecto.Migration

  def change do
    create table(:processes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :code, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
