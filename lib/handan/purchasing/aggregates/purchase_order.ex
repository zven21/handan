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

  alias Handan.Purchasing.Events.{
    PurchaseOrderCreated,
    PurchaseOrderDeleted,
    PurchaseOrderConfirmed,
    PurchaseOrderItemAdded,
    PurchaseOrderStatusChanged,
    ReceiptNoteCreated,
    ReceiptNoteConfirmed,
    ReceiptNoteCompleted,
    ReceiptNoteItemAdded
  }

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

  def execute(%__MODULE__{purchase_order_uuid: purchase_order_uuid} = state, %DeletePurchaseOrder{purchase_order_uuid: purchase_order_uuid} = cmd) do
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
        status: event.status
    }
  end

  def apply(%__MODULE__{} = state, %PurchaseOrderDeleted{} = event) do
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
end
