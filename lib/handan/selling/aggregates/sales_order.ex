defmodule Handan.Selling.Aggregates.SalesOrder do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type
  import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1, decimal_add: 2, decimal_sub: 2]

  deftype do
    field :sales_order_uuid, Ecto.UUID
    field :store_uuid, Ecto.UUID
    field :customer_uuid, Ecto.UUID
    field :customer_name, :string
    field :customer_address, :string
    field :warehouse_uuid, Ecto.UUID

    field :total_amount, :decimal
    field :total_qty, :decimal

    field :delivery_status, :string
    field :billing_status, :string
    field :status, :string

    # 销售订单项
    field :sales_items, :map, default: %{}

    # 发货单
    field :delivery_notes, :map, default: %{}
    field :delivery_note_items, :map, default: %{}

    # 销售发票
    field :sales_invoices, :map, default: %{}

    field :deleted?, :boolean, default: false
  end

  alias Handan.Selling.Commands.{
    CreateSalesOrder,
    DeleteSalesOrder,
    CreateDeliveryNote,
    ConfirmDeliveryNote,
    ConfirmSalesOrder
  }

  alias Handan.Selling.Events.{
    SalesOrderCreated,
    SalesOrderDeleted,
    SalesOrderItemAdded,
    SalesOrderItemAdjusted,
    DeliveryNoteCreated,
    DeliveryNoteItemAdded,
    SalesOrderStatusChanged,
    DeliveryNoteConfirmed,
    SalesOrderConfirmed
  }

  @doc """
  停止已删除的聚合
  """
  def after_event(%SalesOrderDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # 创建销售订单
  def execute(%__MODULE__{sales_order_uuid: nil}, %CreateSalesOrder{} = cmd) do
    sales_order_evt = %SalesOrderCreated{
      sales_order_uuid: cmd.sales_order_uuid,
      customer_uuid: cmd.customer_uuid,
      status: :draft,
      customer_name: cmd.customer_name,
      customer_address: cmd.customer_address,
      total_amount: cmd.total_amount,
      total_qty: cmd.total_qty,
      warehouse_uuid: cmd.warehouse_uuid,
      delivery_status: :not_delivered,
      billing_status: :not_billed
    }

    sales_items_evt =
      cmd.sales_items
      |> Enum.map(fn sales_item ->
        %SalesOrderItemAdded{
          sales_order_item_uuid: sales_item.sales_order_item_uuid,
          sales_order_uuid: sales_item.sales_order_uuid,
          item_uuid: sales_item.item_uuid,
          item_name: sales_item.item_name,
          ordered_qty: sales_item.ordered_qty,
          delivered_qty: 0,
          remaining_qty: sales_item.ordered_qty,
          unit_price: sales_item.unit_price,
          amount: sales_item.amount
        }
      end)

    [sales_order_evt | sales_items_evt]
    |> List.flatten()
  end

  def execute(_, %CreateSalesOrder{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{sales_order_uuid: sales_order_uuid} = state, %ConfirmSalesOrder{sales_order_uuid: sales_order_uuid} = cmd) do
    sales_order_confirmed_evt = %SalesOrderConfirmed{
      sales_order_uuid: sales_order_uuid,
      status: :to_deliver_and_bill
    }

    status_changed_evt = %SalesOrderStatusChanged{
      sales_order_uuid: sales_order_uuid,
      from_status: :draft,
      to_status: :to_deliver_and_bill,
      from_delivery_status: state.delivery_status,
      to_delivery_status: state.delivery_status,
      from_billing_status: state.billing_status,
      to_billing_status: state.billing_status
    }

    [sales_order_confirmed_evt, status_changed_evt]
  end

  def execute(%__MODULE__{} = _state, %DeleteSalesOrder{} = cmd) do
    sales_order_evt = %SalesOrderDeleted{
      sales_order_uuid: cmd.sales_order_uuid
    }

    sales_order_evt
  end

  def execute(_, %DeleteSalesOrder{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{} = state, %CreateDeliveryNote{} = cmd) do
    if Map.has_key?(state.delivery_notes, cmd.delivery_note_uuid) do
      {:error, :delivery_note_already_exists}
    else
      delivery_note_created_evt = %DeliveryNoteCreated{
        delivery_note_uuid: cmd.delivery_note_uuid,
        sales_order_uuid: state.sales_order_uuid,
        customer_uuid: state.customer_uuid,
        customer_name: state.customer_name,
        customer_address: state.customer_address,
        status: "draft",
        total_qty: cmd.total_qty,
        total_amount: cmd.total_amount
      }

      delivery_note_items_evt =
        cmd.delivery_items
        |> Enum.map(fn delivery_item ->
          %DeliveryNoteItemAdded{
            delivery_note_item_uuid: delivery_item.delivery_note_item_uuid,
            delivery_note_uuid: cmd.delivery_note_uuid,
            sales_order_item_uuid: delivery_item.sales_order_item_uuid,
            sales_order_uuid: state.sales_order_uuid,
            item_uuid: delivery_item.item_uuid,
            actual_qty: delivery_item.actual_qty,
            amount: delivery_item.amount,
            unit_price: delivery_item.unit_price,
            item_name: delivery_item.item_name
          }
        end)

      [delivery_note_created_evt | delivery_note_items_evt]
      |> List.flatten()
    end
  end

  def execute(_, %CreateDeliveryNote{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{sales_order_uuid: sales_order_uuid} = state, %ConfirmDeliveryNote{delivery_note_uuid: delivery_note_uuid} = cmd) do
    if Map.has_key?(state.delivery_notes, delivery_note_uuid) do
      delivery_note = Map.get(state.delivery_notes, delivery_note_uuid)

      delivery_note_confirmed_evt = %DeliveryNoteConfirmed{
        delivery_note_uuid: delivery_note.delivery_note_uuid,
        sales_order_uuid: sales_order_uuid,
        status: :to_deliver
      }

      sales_order_items_evt =
        state.delivery_note_items
        |> Map.values()
        |> Enum.filter(fn delivery_item -> delivery_item.delivery_note_uuid == cmd.delivery_note_uuid end)
        |> Enum.map(fn delivery_item ->
          sales_order_item = Map.get(state.sales_items, delivery_item.sales_order_item_uuid)

          new_delivered_qty = decimal_add(sales_order_item.delivered_qty, delivery_item.actual_qty)
          new_remaining_qty = decimal_sub(sales_order_item.ordered_qty, new_delivered_qty)

          %SalesOrderItemAdjusted{
            sales_order_item_uuid: delivery_item.sales_order_item_uuid,
            sales_order_uuid: sales_order_uuid,
            delivered_qty: new_delivered_qty,
            remaining_qty: new_remaining_qty
          }
        end)

      # inventory_unit_outbound_evt =
      #   state.delivery_note_items
      #   |> Map.values()
      #   |> Enum.filter(fn delivery_item -> delivery_item.delivery_note_uuid == cmd.delivery_note_uuid end)
      #   |> Enum.map(fn delivery_item ->
      #     %StockEntryOutbound{
      #       stock_entry_uuid: Ecto.UUID.generate(),
      #       thread_type: "sales_order_item",
      #       thread_uuid: delivery_item.sales_order_item_uuid,
      #       item_uuid: delivery_item.item_uuid,
      #       item_name: delivery_item.item_name,
      #       warehouse_uuid: delivery_item.warehouse_uuid,
      #       store_uuid: delivery_item.store_uuid,
      #       qty: delivery_item.stock_qty
      #     }
      #   end)

      to_delivery_status = calculate_delivery_status(state, sales_order_items_evt)

      sales_order_status_changed_evt = %SalesOrderStatusChanged{
        sales_order_uuid: sales_order_uuid,
        from_billing_status: state.billing_status,
        to_billing_status: state.billing_status,
        from_status: state.status,
        to_status: calculate_status(%{delivery_status: to_delivery_status, billing_status: state.billing_status}),
        from_delivery_status: state.delivery_status,
        to_delivery_status: to_delivery_status
      }

      [delivery_note_confirmed_evt, sales_order_items_evt, sales_order_status_changed_evt]
      |> List.flatten()
    else
      {:error, :delivery_note_not_found}
    end
  end

  def execute(_, %ConfirmDeliveryNote{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %SalesOrderCreated{} = evt) do
    %__MODULE__{
      state
      | sales_order_uuid: evt.sales_order_uuid,
        status: evt.status,
        delivery_status: evt.delivery_status,
        billing_status: evt.billing_status,
        customer_name: evt.customer_name,
        customer_uuid: evt.customer_uuid,
        warehouse_uuid: evt.warehouse_uuid,
        customer_address: evt.customer_address,
        total_amount: evt.total_amount,
        total_qty: evt.total_qty
    }
  end

  def apply(%__MODULE__{} = state, %SalesOrderDeleted{} = _evt) do
    %__MODULE__{state | deleted?: true}
  end

  def apply(%__MODULE__{} = state, %SalesOrderItemAdded{} = evt) do
    new_sales_items = Map.put(state.sales_items, evt.sales_order_item_uuid, Map.from_struct(evt))

    %__MODULE__{
      state
      | sales_items: new_sales_items
    }
  end

  def apply(%__MODULE__{} = state, %DeliveryNoteCreated{} = evt) do
    new_delivery_notes = Map.put(state.delivery_notes, evt.delivery_note_uuid, Map.from_struct(evt))

    %__MODULE__{
      state
      | delivery_notes: new_delivery_notes
    }
  end

  def apply(%__MODULE__{} = state, %DeliveryNoteItemAdded{} = evt) do
    new_delivery_note_items = Map.put(state.delivery_note_items, evt.delivery_note_item_uuid, Map.from_struct(evt))

    %__MODULE__{
      state
      | delivery_note_items: new_delivery_note_items
    }
  end

  def apply(%__MODULE__{} = state, %DeliveryNoteConfirmed{} = evt) do
    state
  end

  def apply(%__MODULE__{} = state, %SalesOrderConfirmed{} = evt) do
    %__MODULE__{
      state
      | status: evt.status
    }
  end

  def apply(%__MODULE__{} = state, %SalesOrderStatusChanged{} = evt) do
    %__MODULE__{
      state
      | status: evt.to_status,
        delivery_status: evt.to_delivery_status,
        billing_status: evt.to_billing_status
    }
  end

  def apply(%__MODULE__{} = state, %SalesOrderItemAdjusted{} = evt) do
    updated_sales_items =
      state.sales_items
      |> Map.update!(evt.sales_order_item_uuid, fn item ->
        item
        |> Map.merge(Map.from_struct(evt))
      end)

    %__MODULE__{
      state
      | sales_items: updated_sales_items
    }
  end

  defp calculate_delivery_status(%{total_qty: total_qty} = state, updated_sales_items) do
    deliveried_qty =
      state.sales_items
      |> Map.values()
      |> Enum.map(fn sales_item ->
        updated_sales_items
        |> Enum.find(fn updated_sales_item -> updated_sales_item.sales_order_item_uuid == sales_item.sales_order_item_uuid end)
        |> case do
          nil -> sales_item
          updated_sales_item -> Map.merge(sales_item, updated_sales_item)
        end
      end)
      |> Enum.reduce(0, fn sales_item, acc ->
        decimal_add(acc, sales_item.delivered_qty)
      end)

    case deliveried_qty do
      value when value == total_qty -> :fully_delivered
      0 -> :not_delivered
      _ -> :partly_delivered
    end
  end

  defp calculate_status(%{delivery_status: :fully_delivered, billing_status: :fully_billed}), do: :completed
  defp calculate_status(%{delivery_status: :fully_delivered, billing_status: :partly_billed}), do: :to_bill
  defp calculate_status(%{delivery_status: :fully_delivered, billing_status: :not_billed}), do: :to_bill
  defp calculate_status(%{delivery_status: :partly_delivered, billing_status: :fully_billed}), do: :to_deliver_and_bill
  defp calculate_status(%{delivery_status: :partly_delivered, billing_status: :partly_billed}), do: :to_deliver_and_bill
  defp calculate_status(%{delivery_status: :partly_delivered, billing_status: :not_billed}), do: :to_deliver_and_bill
end
