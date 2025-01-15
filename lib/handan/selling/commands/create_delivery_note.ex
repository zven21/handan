defmodule Handan.Selling.Commands.CreateDeliveryNote do
  @moduledoc false

  @required_fields ~w(delivery_note_uuid sales_order_uuid delivery_items)a

  use Handan.EventSourcing.Command

  defcommand do
    field :delivery_note_uuid, Ecto.UUID
    field :sales_order_uuid, Ecto.UUID

    field :code, :string
    field :total_qty, :decimal
    field :total_amount, :decimal
    field :is_draft, :boolean, default: false

    field :customer_uuid, Ecto.UUID
    field :customer_name, :string
    field :customer_address, :string
    field :delivery_items, {:array, :map}
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1, decimal_add: 2, decimal_mult: 2]

    alias Decimal, as: D
    alias Handan.Selling
    alias Handan.Selling.Commands.CreateDeliveryNote

    def enrich(%CreateDeliveryNote{} = cmd, _) do
      handle_delivery_item_fn = fn cmd ->
        updated_delivery_items =
          cmd.delivery_items
          |> Enum.map(fn delivery_item ->
            case Selling.get_sales_order_item(delivery_item.sales_order_item_uuid) do
              {:ok, sales_order_item} ->
                if D.gte?(to_decimal(sales_order_item.remaining_qty), to_decimal(delivery_item.actual_qty)) do
                  delivery_item
                  |> Map.put_new(:delivery_note_item_uuid, Ecto.UUID.generate())
                  |> Map.put(:item_name, sales_order_item.item_name)
                  |> Map.put(:item_uuid, sales_order_item.item_uuid)
                  |> Map.put(:delivery_note_uuid, cmd.delivery_note_uuid)
                  |> Map.put(:amount, decimal_mult(delivery_item.actual_qty, sales_order_item.unit_price))
                  |> Map.put(:stock_uom_uuid, sales_order_item.stock_uom_uuid)
                  |> Map.put(:uom_name, sales_order_item.uom_name)
                  |> Map.put(:unit_price, sales_order_item.unit_price)
                else
                  Map.put(delivery_item, :item_uuid, nil)
                end

              _ ->
                Map.put(delivery_item, :item_uuid, nil)
            end
          end)

        total_qty =
          updated_delivery_items
          |> Enum.reduce(D.new(0), fn delivery_item, acc ->
            decimal_add(acc, delivery_item.actual_qty)
          end)

        total_amount =
          updated_delivery_items
          |> Enum.reduce(D.new(0), fn delivery_item, acc ->
            decimal_add(acc, delivery_item.amount)
          end)

        %{cmd | delivery_items: updated_delivery_items, total_qty: total_qty, total_amount: total_amount}
      end

      %{cmd | code: Handan.Infrastructure.Helper.generate_code("DN")}
      |> handle_delivery_item_fn.()
      |> validator()
    end

    defp validator(cmd) do
      case cmd do
        %{delivery_items: delivery_items} ->
          delivery_items
          |> Enum.all?(fn delivery_item -> delivery_item.item_uuid != nil end)
          |> case do
            true -> {:ok, cmd}
            false -> {:error, %{delivery_item: "not found"}}
          end

        _ ->
          {:ok, cmd}
      end
    end
  end
end
