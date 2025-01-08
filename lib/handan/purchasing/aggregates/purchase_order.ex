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

  alias Handan.Purchasing.Events.{
    PurchaseOrderCreated,
    PurchaseOrderDeleted,
    PurchaseOrderConfirmed,
    PurchaseOrderItemAdded
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
          purchase_order_item_uuid: purchase_item.purchase_order_item_uuid,
          purchase_order_uuid: cmd.purchase_order_uuid,
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

  def execute(%__MODULE__{purchase_order_uuid: sales_order_uuid} = state, %DeletePurchaseOrder{purchase_order_uuid: sales_order_uuid} = cmd) do
    purchase_order_evt = %PurchaseOrderDeleted{
      purchase_order_uuid: cmd.purchase_order_uuid
    }

    [purchase_order_evt]
  end

  def execute(_, %DeletePurchaseOrder{}), do: {:error, :not_allowed}

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
end
