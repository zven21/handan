defmodule Handan.Finance.Commands.CreatePaymentEntry do
  @moduledoc false

  @required_fields ~w(payment_entry_uuid party_type party_uuid payment_method_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :payment_entry_uuid, Ecto.UUID
    field :memo, :string
    field :type, :string
    field :code, :string
    field :attachments, {:array, :string}, default: []
    field :party_name, :string
    field :party_type, :string
    field :party_uuid, Ecto.UUID
    field :purchase_invoice_ids, {:array, Ecto.UUID}, default: []
    field :sales_invoice_ids, {:array, Ecto.UUID}, default: []
    field :total_amount, :decimal
    field :payment_method_uuid, Ecto.UUID
    field :payment_method_name, :string
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    import Handan.Infrastructure.DecimalHelper, only: [decimal_sum: 1]

    alias Handan.Finance.Commands.CreatePaymentEntry

    def enrich(%CreatePaymentEntry{} = cmd, _) do
      handle_party_fn = fn cmd ->
        case cmd.party_type do
          "customer" ->
            {:ok, customer} = Handan.Selling.get_customer(cmd.party_uuid)
            %{cmd | party_name: customer.name}

          "supplier" ->
            {:ok, supplier} = Handan.Purchasing.get_supplier(cmd.party_uuid)
            %{cmd | party_name: supplier.name}
        end
      end

      handle_total_amount_fn = fn cmd ->
        case cmd.party_type do
          "customer" ->
            total_amount =
              cmd.sales_invoice_ids
              |> Enum.map(fn sales_invoice_id ->
                {:ok, sales_invoice} = Handan.Selling.get_sales_invoice(sales_invoice_id)
                sales_invoice.amount
              end)
              |> decimal_sum()

            %{cmd | total_amount: total_amount}

          "supplier" ->
            total_amount =
              cmd.purchase_invoice_ids
              |> Enum.map(fn purchase_invoice_id ->
                {:ok, purchase_invoice} = Handan.Purchasing.get_purchase_invoice(purchase_invoice_id)
                purchase_invoice.amount
              end)
              |> decimal_sum()

            %{cmd | total_amount: total_amount}
        end
      end

      handle_payment_method_fn = fn ->
        {:ok, payment_method} = Handan.Finance.get_payment_method(cmd.payment_method_uuid)
        %{cmd | payment_method_name: payment_method.name}
      end

      %{cmd | code: Handan.Infrastructure.Helper.generate_code("PE")}
      |> handle_party_fn.()
      |> handle_payment_method_fn.()
      |> handle_total_amount_fn.()
      |> then(&{:ok, &1})
    end
  end
end
