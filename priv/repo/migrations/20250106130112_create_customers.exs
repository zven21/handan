defmodule Handan.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :name, :string
      add :address, :string
      add :balance, :decimal
      add :store_uuid, :binary_id

      timestamps(type: :utc_datetime)
    end

    create index(:customers, [:store_uuid])
  end
end
