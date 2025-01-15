defmodule Handan.Selling.Commands.CreateSalesInvoice do
  @moduledoc false

  @required_fields ~w(sales_invoice_uuid sales_order_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :sales_invoice_uuid, Ecto.UUID
    field :sales_order_uuid, Ecto.UUID
    field :code, :string
    field :amount, :decimal, default: 0
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    alias Handan.Selling.Commands.CreateSalesInvoice

    def enrich(%CreateSalesInvoice{} = cmd, _) do
      {:ok, %{cmd | code: Handan.Infrastructure.Helper.generate_code("SI")}}
    end
  end
end
