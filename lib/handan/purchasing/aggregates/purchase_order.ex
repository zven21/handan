defmodule Handan.Purchasing.Aggregates.PurchaseOrder do
  @moduledoc """
  停止已删除的聚合
  """
  @required_fields []

  use Handan.EventSourcing.Type
  import Handan.Infrastructure.DecimalHelper, only: [decimal_add: 2, decimal_sub: 2]

  alias Decimal, as: D

  deftype do
    field :purchase_order_uuid, Ecto.UUID
    field :supplier_uuid, Ecto.UUID
    field :supplier_name, :string
    field :supplier_address, :string
    field :warehouse_uuid, Ecto.UUID

    field :total_amount, :decimal
    field :paid_amount, :decimal, default: 0
    field :remaining_amount, :decimal, default: 0

    field :total_qty, :decimal
    field :received_qty, :decimal, default: 0
    field :remaining_qty, :decimal, default: 0

    field :receipt_status, :string
    field :billing_status, :string
    field :status, :string

    # 采购订单项
    field :purchase_items, :map, default: %{}

    # 收货单
    field :receipt_notes, :map, default: %{}
    field :receipt_note_items, :map, default: %{}

    # 采购发票
    field :purchase_invoices, :map, default: %{}

    field :deleted?, :boolean, default: false
  end

  alias Handan.Purchasing.Commands.{
    CreatePurchaseOrder,
    DeletePurchaseOrder,
    ConfirmPurchaseOrder
  }

  alias Handan.Purchasing.Commands.{
    CreateReceiptNote,
    ConfirmReceiptNote,
    CompleteReceiptNote
  }

  alias Handan.Purchasing.Commands.{
    CreatePurchaseInvoice,
    ConfirmPurchaseInvoice
  }

  alias Handan.Purchasing.Events.{
    PurchaseOrderCreated,
    PurchaseOrderDeleted,
    PurchaseOrderConfirmed,
    PurchaseOrderItemAdded,
    PurchaseOrderStatusChanged,
    PurchaseOrderItemAdjusted,
    ReceiptNoteCreated,
    ReceiptNoteConfirmed,
    ReceiptNoteCompleted,
    ReceiptNoteItemAdded,
    PurchaseOrderSummaryChanged,
    PurchaseInvoiceCreated,
    PurchaseInvoiceConfirmed
  }

  alias Handan.Stock.Events.InventoryUnitInbound

  @doc """
  停止已删除的聚合
  """
  def after_event(%PurchaseOrderDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  def execute(%__MODULE__{purchase_order_uuid: nil}, %CreatePurchaseOrder{} = cmd) do
    purchase_order_evt = %PurchaseOrderCreated{
      purchase_order_uuid: cmd.purchase_order_uuid,
      supplier_uuid: cmd.supplier_uuid,
      supplier_name: cmd.supplier_name,
      supplier_address: cmd.supplier_address,
      warehouse_uuid: cmd.warehouse_uuid,
      total_amount: cmd.total_amount,
      paid_amount: 0,
      remaining_amount: cmd.total_amount,
      total_qty: cmd.total_qty,
      received_qty: 0,
      remaining_qty: cmd.total_qty,
      status: :draft,
      receipt_status: :not_received,
      billing_status: :not_billed
    }

    purchase_items_evt =
      cmd.purchase_items
      |> Enum.map(fn purchase_item ->
        %PurchaseOrderItemAdded{
          purchase_order_uuid: cmd.purchase_order_uuid,
          purchase_order_item_uuid: purchase_item.purchase_order_item_uuid,
          item_uuid: purchase_item.item_uuid,
          item_name: purchase_item.item_name,
          ordered_qty: purchase_item.ordered_qty,
          received_qty: 0,
          remaining_qty: purchase_item.ordered_qty,
          unit_price: purchase_item.unit_price,
          amount: purchase_item.amount,
          stock_uom_uuid: purchase_item.stock_uom_uuid,
          uom_name: purchase_item.uom_name
        }
      end)

    [purchase_order_evt | purchase_items_evt]
    |> List.flatten()
  end

  def execute(_, %CreatePurchaseOrder{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{purchase_order_uuid: purchase_order_uuid} = _state, %DeletePurchaseOrder{purchase_order_uuid: purchase_order_uuid} = _cmd) do
    purchase_order_evt = %PurchaseOrderDeleted{
      purchase_order_uuid: purchase_order_uuid
    }

    [purchase_order_evt]
  end

  def execute(_, %DeletePurchaseOrder{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{status: :draft, purchase_order_uuid: purchase_order_uuid} = state, %ConfirmPurchaseOrder{purchase_order_uuid: purchase_order_uuid}) do
    purchase_order_evt = %PurchaseOrderConfirmed{
      purchase_order_uuid: purchase_order_uuid,
      status: :to_receive_and_bill
    }

    status_changed_evt = %PurchaseOrderStatusChanged{
      purchase_order_uuid: purchase_order_uuid,
      from_status: :draft,
      to_status: :to_receive_and_bill,
      from_receipt_status: state.receipt_status,
      to_receipt_status: state.receipt_status,
      from_billing_status: state.billing_status,
      to_billing_status: state.billing_status
    }

    [purchase_order_evt, status_changed_evt]
  end

  def execute(%__MODULE__{} = state, %CreateReceiptNote{} = cmd) do
    if Map.has_key?(state.receipt_notes, cmd.receipt_note_uuid) do
      {:error, :receipt_note_already_exists}
    else
      receipt_note_created_evt = %ReceiptNoteCreated{
        receipt_note_uuid: cmd.receipt_note_uuid,
        purchase_order_uuid: state.purchase_order_uuid,
        supplier_uuid: state.supplier_uuid,
        supplier_name: state.supplier_name,
        supplier_address: state.supplier_address,
        warehouse_uuid: state.warehouse_uuid,
        status: "draft",
        total_qty: cmd.total_qty,
        total_amount: cmd.total_amount
      }

      receipt_note_items_evt =
        cmd.receipt_items
        |> Enum.map(fn receipt_item ->
          %ReceiptNoteItemAdded{
            receipt_note_item_uuid: receipt_item.receipt_note_item_uuid,
            receipt_note_uuid: cmd.receipt_note_uuid,
            purchase_order_item_uuid: receipt_item.purchase_order_item_uuid,
            purchase_order_uuid: state.purchase_order_uuid,
            item_uuid: receipt_item.item_uuid,
            stock_uom_uuid: receipt_item.stock_uom_uuid,
            uom_name: receipt_item.uom_name,
            actual_qty: receipt_item.actual_qty,
            amount: receipt_item.amount,
            unit_price: receipt_item.unit_price,
            item_name: receipt_item.item_name
          }
        end)

      [receipt_note_created_evt | receipt_note_items_evt]
      |> List.flatten()
    end
  end

  def execute(_, %CreateReceiptNote{}), do: {:error, :not_allowed}

  def execute(
        %__MODULE__{purchase_order_uuid: purchase_order_uuid} = state,
        %ConfirmReceiptNote{purchase_order_uuid: purchase_order_uuid, receipt_note_uuid: receipt_note_uuid} = cmd
      ) do
    if Map.has_key?(state.receipt_notes, receipt_note_uuid) do
      # receipt_note = Map.get(state.receipt_notes, receipt_note_uuid)

      receipt_note_confirmed_evt = %ReceiptNoteConfirmed{
        receipt_note_uuid: receipt_note_uuid,
        purchase_order_uuid: purchase_order_uuid,
        status: :to_receive
      }

      purchase_order_items_evt =
        state.receipt_note_items
        |> Map.values()
        |> Enum.filter(fn receipt_item -> receipt_item.receipt_note_uuid == cmd.receipt_note_uuid end)
        |> Enum.map(fn receipt_item ->
          purchase_order_item = Map.get(state.purchase_items, receipt_item.purchase_order_item_uuid)

          new_received_qty = decimal_add(purchase_order_item.received_qty, receipt_item.actual_qty)
          new_remaining_qty = decimal_sub(purchase_order_item.ordered_qty, new_received_qty)

          %PurchaseOrderItemAdjusted{
            purchase_order_item_uuid: receipt_item.purchase_order_item_uuid,
            purchase_order_uuid: purchase_order_uuid,
            item_uuid: receipt_item.item_uuid,
            received_qty: new_received_qty,
            remaining_qty: new_remaining_qty
          }
        end)

      to_receipt_status = calculate_receipt_status(state, purchase_order_items_evt)

      purchase_order_status_changed_evt = %PurchaseOrderStatusChanged{
        purchase_order_uuid: purchase_order_uuid,
        from_billing_status: state.billing_status,
        to_billing_status: state.billing_status,
        from_status: state.status,
        to_status: calculate_status(%{receipt_status: to_receipt_status, billing_status: state.billing_status}),
        from_receipt_status: state.receipt_status,
        to_receipt_status: to_receipt_status
      }

      [receipt_note_confirmed_evt, purchase_order_items_evt, purchase_order_status_changed_evt]
      |> List.flatten()
    else
      {:error, :receipt_note_not_found}
    end
  end

  def execute(_, %ConfirmReceiptNote{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{} = state, %CreatePurchaseInvoice{} = cmd) do
    if Map.has_key?(state.purchase_invoices, cmd.purchase_invoice_uuid) do
      {:error, :purchase_invoice_already_exists}
    else
      case D.gte?(state.remaining_amount, cmd.amount) do
        true ->
          purchase_invoice_evt = %PurchaseInvoiceCreated{
            purchase_invoice_uuid: cmd.purchase_invoice_uuid,
            purchase_order_uuid: state.purchase_order_uuid,
            supplier_uuid: state.supplier_uuid,
            supplier_name: state.supplier_name,
            supplier_address: state.supplier_address,
            amount: cmd.amount
          }

          purchase_invoice_evt

        false ->
          {:error, :amount_too_large}
      end
    end
  end

  def execute(_, %CreatePurchaseInvoice{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{purchase_order_uuid: purchase_order_uuid} = state, %ConfirmPurchaseInvoice{purchase_order_uuid: purchase_order_uuid} = cmd) do
    if Map.has_key?(state.purchase_invoices, cmd.purchase_invoice_uuid) do
      purchase_invoice = Map.get(state.purchase_invoices, cmd.purchase_invoice_uuid)

      case D.gte?(state.remaining_amount, purchase_invoice.amount) do
        true ->
          new_paid_amount = decimal_add(state.paid_amount, purchase_invoice.amount)
          new_remaining_amount = decimal_sub(state.total_amount, new_paid_amount)

          purchase_invoice_confirmed_evt = %PurchaseInvoiceConfirmed{
            purchase_invoice_uuid: purchase_invoice.purchase_invoice_uuid,
            purchase_order_uuid: purchase_order_uuid,
            status: :submitted
          }

          purchase_order_summary_changed_evt = %PurchaseOrderSummaryChanged{
            purchase_order_uuid: purchase_order_uuid,
            paid_amount: new_paid_amount,
            remaining_amount: new_remaining_amount,
            received_qty: state.received_qty,
            remaining_qty: state.remaining_qty
          }

          to_billing_status = calculate_billing_status(state, state.purchase_invoices)

          purchase_order_status_changed_evt = %PurchaseOrderStatusChanged{
            purchase_order_uuid: purchase_order_uuid,
            from_billing_status: state.billing_status,
            to_billing_status: to_billing_status,
            from_receipt_status: state.receipt_status,
            to_receipt_status: state.receipt_status,
            from_status: state.status,
            to_status: calculate_status(%{receipt_status: state.receipt_status, billing_status: to_billing_status})
          }

          [purchase_invoice_confirmed_evt, purchase_order_summary_changed_evt, purchase_order_status_changed_evt]
          |> List.flatten()

        false ->
          {:error, :amount_too_large}
      end
    else
      {:error, :sales_invoice_not_found}
    end
  end

  def execute(_, %ConfirmPurchaseInvoice{}), do: {:error, :not_allowed}

  def execute(
        %__MODULE__{purchase_order_uuid: purchase_order_uuid} = state,
        %CompleteReceiptNote{purchase_order_uuid: purchase_order_uuid, receipt_note_uuid: receipt_note_uuid} = _cmd
      ) do
    if Map.has_key?(state.receipt_notes, receipt_note_uuid) do
      receipt_note = Map.get(state.receipt_notes, receipt_note_uuid)

      receipt_note_completed_evt = %ReceiptNoteCompleted{
        receipt_note_uuid: receipt_note.receipt_note_uuid,
        purchase_order_uuid: purchase_order_uuid,
        status: :completed
      }

      receipt_note_item_evts =
        state.receipt_note_items
        |> Map.values()
        |> Enum.filter(fn receipt_item -> receipt_item.receipt_note_uuid == receipt_note_uuid end)
        |> Enum.map(fn receipt_item ->
          %InventoryUnitInbound{
            item_uuid: receipt_item.item_uuid,
            warehouse_uuid: state.warehouse_uuid,
            stock_uom_uuid: receipt_item.stock_uom_uuid,
            actual_qty: receipt_item.actual_qty,
            type: "inbound"
          }
        end)

      [receipt_note_item_evts, receipt_note_completed_evt]
      |> List.flatten()
    else
      {:error, :receipt_note_not_found}
    end
  end

  def execute(_, %CompleteReceiptNote{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = purchase_order, %PurchaseOrderCreated{} = event) do
    %__MODULE__{
      purchase_order
      | purchase_order_uuid: event.purchase_order_uuid,
        supplier_uuid: event.supplier_uuid,
        supplier_name: event.supplier_name,
        supplier_address: event.supplier_address,
        warehouse_uuid: event.warehouse_uuid,
        total_amount: event.total_amount,
        paid_amount: event.paid_amount,
        remaining_amount: event.remaining_amount,
        total_qty: event.total_qty,
        received_qty: event.received_qty,
        remaining_qty: event.remaining_qty,
        status: event.status,
        receipt_status: event.receipt_status,
        billing_status: event.billing_status
    }
  end

  def apply(%__MODULE__{} = state, %PurchaseOrderDeleted{} = _event) do
    %__MODULE__{state | deleted?: true}
  end

  def apply(%__MODULE__{} = state, %PurchaseOrderItemAdded{} = evt) do
    new_purchase_items = Map.put(state.purchase_items, evt.purchase_order_item_uuid, Map.from_struct(evt))

    %__MODULE__{
      state
      | purchase_items: new_purchase_items
    }
  end

  def apply(%__MODULE__{} = state, %PurchaseOrderConfirmed{} = evt) do
    %__MODULE__{state | status: evt.status}
  end

  def apply(%__MODULE__{} = state, %PurchaseOrderStatusChanged{} = evt) do
    %__MODULE__{state | status: evt.to_status, receipt_status: evt.to_receipt_status, billing_status: evt.to_billing_status}
  end

  def apply(%__MODULE__{} = state, %ReceiptNoteCreated{} = evt) do
    new_receipt_notes = Map.put(state.receipt_notes, evt.receipt_note_uuid, Map.from_struct(evt))

    %__MODULE__{state | receipt_notes: new_receipt_notes}
  end

  def apply(%__MODULE__{} = state, %ReceiptNoteConfirmed{} = evt) do
    %__MODULE__{state | receipt_status: evt.status}
  end

  def apply(%__MODULE__{} = state, %ReceiptNoteItemAdded{} = evt) do
    new_receipt_note_items = Map.put(state.receipt_note_items, evt.receipt_note_item_uuid, Map.from_struct(evt))

    %__MODULE__{
      state
      | receipt_note_items: new_receipt_note_items
    }
  end

  def apply(%__MODULE__{} = state, %PurchaseOrderItemAdjusted{} = evt) do
    updated_purchase_items =
      state.purchase_items
      |> Map.update!(evt.purchase_order_item_uuid, fn item ->
        item
        |> Map.merge(Map.from_struct(evt))
      end)

    %__MODULE__{state | purchase_items: updated_purchase_items}
  end

  def apply(%__MODULE__{} = state, %PurchaseInvoiceCreated{} = evt) do
    new_purchase_invoices = Map.put(state.purchase_invoices, evt.purchase_invoice_uuid, Map.from_struct(evt))

    %__MODULE__{state | purchase_invoices: new_purchase_invoices}
  end

  def apply(%__MODULE__{} = state, %PurchaseInvoiceConfirmed{} = evt) do
    updated_purchase_invoices =
      state.purchase_invoices
      |> Map.update!(evt.purchase_invoice_uuid, fn item ->
        item
        |> Map.merge(Map.from_struct(evt))
      end)

    %__MODULE__{state | purchase_invoices: updated_purchase_invoices}
  end

  def apply(%__MODULE__{} = state, %PurchaseOrderSummaryChanged{} = evt) do
    %__MODULE__{state | paid_amount: evt.paid_amount, remaining_amount: evt.remaining_amount, received_qty: evt.received_qty, remaining_qty: evt.remaining_qty}
  end

  def apply(%__MODULE__{} = state, %ReceiptNoteCompleted{} = evt) do
    updated_receipt_notes =
      state.receipt_notes
      |> Map.update!(evt.receipt_note_uuid, fn receipt_note ->
        receipt_note
        |> Map.merge(Map.from_struct(evt))
      end)

    %__MODULE__{
      state
      | receipt_notes: updated_receipt_notes
    }
  end

  def apply(%__MODULE__{} = state, %InventoryUnitInbound{} = _evt) do
    state
  end

  defp calculate_receipt_status(%{total_qty: total_qty} = state, updated_purchase_items) do
    received_qty =
      state.purchase_items
      |> Map.values()
      |> Enum.map(fn purchase_item ->
        updated_purchase_items
        |> Enum.find(fn updated_purchase_item -> updated_purchase_item.purchase_order_item_uuid == purchase_item.purchase_order_item_uuid end)
        |> case do
          nil -> purchase_item
          updated_purchase_item -> Map.merge(purchase_item, updated_purchase_item)
        end
      end)
      |> Enum.reduce(0, fn purchase_item, acc ->
        decimal_add(acc, purchase_item.received_qty)
      end)

    case received_qty do
      value when value == total_qty -> :fully_received
      0 -> :not_received
      _ -> :partly_received
    end
  end

  defp calculate_billing_status(%{total_amount: total_amount} = _state, purchase_invoices) do
    paid_amount =
      purchase_invoices
      |> Map.values()
      |> Enum.reduce(0, fn purchase_invoice, acc ->
        decimal_add(acc, purchase_invoice.amount)
      end)

    case D.eq?(total_amount, paid_amount) do
      true -> :fully_billed
      false -> :partly_billed
    end
  end

  defp calculate_status(%{receipt_status: :fully_received, billing_status: :fully_billed}), do: :completed
  defp calculate_status(%{receipt_status: :fully_received, billing_status: :partly_billed}), do: :to_bill
  defp calculate_status(%{receipt_status: :fully_received, billing_status: :not_billed}), do: :to_bill
  defp calculate_status(%{receipt_status: :partly_received, billing_status: :fully_billed}), do: :to_receive_and_bill
  defp calculate_status(%{receipt_status: :partly_received, billing_status: :partly_billed}), do: :to_receive_and_bill
  defp calculate_status(%{receipt_status: :partly_received, billing_status: :not_billed}), do: :to_receive_and_bill
  defp calculate_status(%{receipt_status: :not_received, billing_status: :fully_billed}), do: :to_receive
  defp calculate_status(%{receipt_status: :not_received, billing_status: :partly_billed}), do: :to_receive
  defp calculate_status(%{receipt_status: :not_received, billing_status: :not_billed}), do: :to_receive
end
