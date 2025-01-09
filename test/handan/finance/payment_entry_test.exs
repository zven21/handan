defmodule Handan.Finance.PaymentEntryTest do
  @moduledoc false

  use Handan.DataCase

  alias Handan.Turbo
  alias Handan.Dispatcher
  alias Handan.Finance.Projections.PaymentEntry

  describe "create payment entry with sales invoice" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order,
      :create_sales_invoice,
      :create_payment_method
    ]

    test "should succeed with valid request", %{payment_method: payment_method, sales_invoice: sales_invoice} do
      request = %{
        payment_entry_uuid: Ecto.UUID.generate(),
        party_type: "customer",
        party_uuid: sales_invoice.customer_uuid,
        payment_method_uuid: payment_method.uuid,
        memo: "memo",
        sales_invoice_ids: [sales_invoice.uuid]
      }

      {:ok, %PaymentEntry{} = payment_entry} = Dispatcher.run(request, :create_payment_entry)
      {:ok, after_invoice} = Handan.Selling.get_sales_invoice(sales_invoice.uuid)
      assert payment_entry.total_amount == sales_invoice.amount
      assert after_invoice.status == :paid
    end
  end

  describe "create payment entry with purchase invoice" do
    setup [
      :register_user,
      :create_company,
      :create_supplier,
      :create_item,
      :create_purchase_order,
      :create_purchase_invoice,
      :create_payment_method
    ]

    test "should succeed with valid request", %{payment_method: payment_method, purchase_invoice: purchase_invoice} do
      request = %{
        payment_entry_uuid: Ecto.UUID.generate(),
        party_type: "supplier",
        party_uuid: purchase_invoice.supplier_uuid,
        payment_method_uuid: payment_method.uuid,
        memo: "memo",
        purchase_invoice_ids: [purchase_invoice.uuid]
      }

      {:ok, %PaymentEntry{} = payment_entry} = Dispatcher.run(request, :create_payment_entry)
      {:ok, after_invoice} = Handan.Purchasing.get_purchase_invoice(purchase_invoice.uuid)
      assert payment_entry.total_amount == purchase_invoice.amount
      assert after_invoice.status == :paid
    end
  end

  describe "delete payment entry" do
    setup [
      :register_user,
      :create_company,
      :create_customer,
      :create_item,
      :create_sales_order,
      :create_sales_invoice,
      :create_payment_method,
      :create_payment_entry
    ]

    test "should succeed with valid request", %{payment_entry: payment_entry} do
      request = %{
        payment_entry_uuid: payment_entry.uuid
      }

      assert :ok = Dispatcher.run(request, :delete_payment_entry)
      assert {:error, :not_found} == Turbo.get(PaymentEntry, payment_entry.uuid)
    end
  end
end
