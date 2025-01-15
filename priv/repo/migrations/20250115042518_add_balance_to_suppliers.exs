defmodule Handan.Repo.Migrations.AddBalanceToSuppliers do
  use Ecto.Migration

  def change do
    alter table(:suppliers) do
      add :balance, :decimal, default: 0
    end

    create index(:suppliers, [:balance])
  end
end
