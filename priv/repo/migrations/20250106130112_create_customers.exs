defmodule Handan.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :name, :string
      add :address, :string
      add :balance, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
