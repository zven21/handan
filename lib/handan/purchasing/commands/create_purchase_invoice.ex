defmodule Handan.Purchasing.Commands.CreatePurchaseInvoice do
  @moduledoc false

  @required_fields ~w(purchase_invoice_uuid purchase_order_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :purchase_invoice_uuid, Ecto.UUID
    field :purchase_order_uuid, Ecto.UUID
    field :amount, :decimal, default: 0
    field :code, :string
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    alias Handan.Purchasing.Commands.CreatePurchaseInvoice

    def enrich(%CreatePurchaseInvoice{} = cmd, _) do
      {:ok, %{cmd | code: Handan.Infrastructure.Helper.generate_code("PI")}}
    end
  end
end
