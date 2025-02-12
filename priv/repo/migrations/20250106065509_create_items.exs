defmodule Handan.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :spec, :string

      add :selling_price, :decimal, precision: 10, scale: 2

      add :default_bom_uuid, :binary_id

      add :default_stock_uom_uuid, :binary_id
      add :default_stock_uom_name, :string

      timestamps(type: :utc_datetime)
    end

    create index(:items, [:default_stock_uom_uuid])
    create index(:items, [:default_bom_uuid])
  end
end
