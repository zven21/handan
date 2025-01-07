defmodule Handan.Selling.Commands.CreateSalesInvoice do
  @moduledoc false

  @required_fields ~w(sales_invoice_uuid sales_order_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :sales_invoice_uuid, Ecto.UUID
    field :sales_order_uuid, Ecto.UUID
    field :amount, :decimal, default: 0
  end
end
