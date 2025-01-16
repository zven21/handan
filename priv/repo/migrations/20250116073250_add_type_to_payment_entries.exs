defmodule Handan.Repo.Migrations.AddTypeToPaymentEntries do
  use Ecto.Migration

  def change do
    alter table(:payment_entries) do
      add :type, :string
    end

    create index(:payment_entries, [:type])
  end
end
