defmodule Handan.Repo.Migrations.CreateBoms do
  use Ecto.Migration

  def change do
    create table(:boms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :item_uuid, :string
      add :item_name, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:boms, [:item_uuid])
  end
end
