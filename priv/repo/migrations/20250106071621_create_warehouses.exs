defmodule Handan.Repo.Migrations.CreateWarehouses do
  use Ecto.Migration

  def change do
    create table(:warehouses, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :name, :string
      add :area, :string
      add :is_default, :boolean, default: false
      add :address, :string
      add :contact_name, :string
      add :contact_mobile, :string
      add :store_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:warehouses, [:store_uuid])
  end
end
