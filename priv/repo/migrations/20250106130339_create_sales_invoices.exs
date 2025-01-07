defmodule Handan.Repo.Migrations.CreateSalesInvoices do
  use Ecto.Migration

  def change do
    create table(:sales_invoices, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :amount, :decimal
      add :status, :string

      add :sales_order_uuid, :binary_id
      add :customer_uuid, :binary_id
      add :customer_name, :string

      timestamps(type: :utc_datetime)
    end

    create index(:sales_invoices, [:customer_uuid])
    create index(:sales_invoices, [:sales_order_uuid])
  end
end
