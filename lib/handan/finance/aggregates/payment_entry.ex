defmodule Handan.Finance.Aggregates.PaymentEntry do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :payment_entry_uuid, Ecto.UUID
    field :party_type, :string
    field :party_uuid, Ecto.UUID
    field :payment_method_uuid, Ecto.UUID
    field :payment_method_name, :string
    field :memo, :string
    field :attachments, {:array, :string}
    field :party_name, :string
    field :purchase_invoice_ids, {:array, Ecto.UUID}
    field :sales_invoice_ids, {:array, Ecto.UUID}
    field :total_amount, :decimal
    field :deleted?, :boolean, default: false
  end

  alias Handan.Finance.Commands.{
    CreatePaymentEntry,
    DeletePaymentEntry
  }

  alias Handan.Finance.Events.{
    PaymentEntryCreated,
    PaymentEntryDeleted
  }

  alias Handan.Selling.Events.SalesInvoicePaid
  alias Handan.Purchasing.Events.PurchaseInvoicePaid

  def after_event(%PaymentEntryDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  def execute(%__MODULE__{payment_entry_uuid: nil}, %CreatePaymentEntry{} = cmd) do
    payment_entry_evt = %PaymentEntryCreated{
      payment_entry_uuid: cmd.payment_entry_uuid,
      party_type: cmd.party_type,
      party_uuid: cmd.party_uuid,
      payment_method_uuid: cmd.payment_method_uuid,
      payment_method_name: cmd.payment_method_name,
      memo: cmd.memo,
      attachments: cmd.attachments,
      party_name: cmd.party_name,
      purchase_invoice_ids: cmd.purchase_invoice_ids,
      sales_invoice_ids: cmd.sales_invoice_ids,
      total_amount: cmd.total_amount
    }

    sales_invoice_paid_evt =
      cmd.sales_invoice_ids
      |> Enum.map(fn sales_invoice_uuid ->
        %SalesInvoicePaid{
          sales_invoice_uuid: sales_invoice_uuid
        }
      end)

    purchase_invoice_paid_evt =
      cmd.purchase_invoice_ids
      |> Enum.map(fn purchase_invoice_uuid ->
        %PurchaseInvoicePaid{
          purchase_invoice_uuid: purchase_invoice_uuid
        }
      end)

    [payment_entry_evt, sales_invoice_paid_evt, purchase_invoice_paid_evt]
    |> List.flatten()
  end

  def execute(_, %CreatePaymentEntry{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{payment_entry_uuid: payment_entry_uuid} = _state, %DeletePaymentEntry{payment_entry_uuid: payment_entry_uuid} = _cmd) do
    payment_entry_evt = %PaymentEntryDeleted{
      payment_entry_uuid: payment_entry_uuid
    }

    # FIXME 需要更改对应的销售发票和采购发票的状态

    payment_entry_evt
  end

  def execute(_, %DeletePaymentEntry{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %PaymentEntryCreated{} = evt) do
    %__MODULE__{
      state
      | payment_entry_uuid: evt.payment_entry_uuid,
        party_type: evt.party_type,
        party_uuid: evt.party_uuid,
        payment_method_uuid: evt.payment_method_uuid,
        payment_method_name: evt.payment_method_name,
        memo: evt.memo,
        attachments: evt.attachments,
        party_name: evt.party_name,
        purchase_invoice_ids: evt.purchase_invoice_ids,
        sales_invoice_ids: evt.sales_invoice_ids,
        total_amount: evt.total_amount
    }
  end

  def apply(%__MODULE__{} = state, %PaymentEntryDeleted{} = _evt) do
    %__MODULE__{state | deleted?: true}
  end

  def apply(%__MODULE__{} = state, %SalesInvoicePaid{} = _evt) do
    state
  end

  def apply(%__MODULE__{} = state, %PurchaseInvoicePaid{} = _evt) do
    state
  end
end
