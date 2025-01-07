defmodule Handan.Repo.Migrations.CreateStockUoms do
  use Ecto.Migration

  def change do
    create table(:stock_uoms, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :item_uuid, :binary_id
      add :uom_uuid, :binary_id
      add :uom_name, :string
      add :conversion_factor, :integer
      add :sequence, :integer

      timestamps(type: :utc_datetime)
    end

    create index(:stock_uoms, [:item_uuid, :uom_uuid])
  end
end
