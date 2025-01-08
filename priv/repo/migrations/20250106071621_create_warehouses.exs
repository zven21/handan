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
      add :contact_email, :string

      timestamps(type: :utc_datetime)
    end
  end
end
