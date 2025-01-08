defmodule Handan.Repo.Migrations.CreateBomItems do
  use Ecto.Migration

  def change do
    create table(:bom_items, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :bom_uuid, :binary_id
      add :item_uuid, :binary_id
      add :item_name, :string
      add :qty, :integer, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:bom_items, [:bom_uuid, :item_uuid])
  end
end
