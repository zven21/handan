defmodule Handan.Selling.Aggregates.SalesOrder do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type
  # import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1]

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
    DeleteSalesOrder
  }

  alias Handan.Selling.Events.{
    SalesOrderCreated,
    SalesOrderDeleted,
    SalesOrderItemAdded
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

  def execute(%__MODULE__{} = _state, %DeleteSalesOrder{} = cmd) do
    sales_order_evt = %SalesOrderDeleted{
      sales_order_uuid: cmd.sales_order_uuid
    }

    sales_order_evt
  end

  def execute(_, %DeleteSalesOrder{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %SalesOrderCreated{} = evt) do
    %__MODULE__{
      state
      | sales_order_uuid: evt.sales_order_uuid,
        status: evt.status,
        delivery_status: evt.delivery_status,
        billing_status: evt.billing_status,
        customer_name: evt.customer_name,
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
end
