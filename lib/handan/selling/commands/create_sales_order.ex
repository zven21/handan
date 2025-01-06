defmodule Handan.Selling.Commands.CreateSalesOrder do
  @moduledoc false

  @required_fields ~w(sales_order_uuid customer_uuid store_uuid sales_items)a

  use Handan.EventSourcing.Command

  defcommand do
    field :sales_order_uuid, Ecto.UUID
    field :customer_uuid, Ecto.UUID

    field :customer_name, :string
    field :customer_address, :string

    field :title, :string
    field :store_uuid, Ecto.UUID
    field :total_amount, :decimal, default: 0
    field :total_qty, :decimal, default: 0
    field :sales_items, {:array, :map}
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1, decimal_mult: 2]
    alias Decimal, as: D
    alias Handan.{Stock, Selling}
    alias Handan.Selling.Commands.CreateSalesOrder

    def enrich(%CreateSalesOrder{store_uuid: _store_uuid} = cmd, _) do
      handle_customer_fn = fn cmd ->
        case Selling.get_customer(cmd.customer_uuid) do
          {:ok, customer} ->
            %{cmd | customer_name: customer.name, customer_address: customer.address}

          _ ->
            %{cmd | customer_uuid: nil}
        end
      end

      handle_sales_item_fn = fn cmd ->
        updated_sales_items =
          cmd.sales_items
          |> Enum.map(fn sales_item ->
            case Stock.get_item(sales_item.item_uuid) do
              {:ok, item} ->
                unit_price = Map.get(sales_item, :unit_price, item.sell_price)

                sales_item
                |> Map.put_new(:sales_order_item_uuid, Ecto.UUID.generate())
                |> Map.put(:item_name, item.name)
                |> Map.put(:unit_price, to_decimal(unit_price))
                |> Map.put(:amount, decimal_mult(unit_price, sales_item.ordered_qty))
                |> Map.put(:store_uuid, cmd.store_uuid)
                |> Map.put(:sales_order_uuid, cmd.sales_order_uuid)

              _ ->
                Map.put(sales_item, :item_uuid, nil)
            end
          end)

        total_amount =
          updated_sales_items
          |> Enum.reduce(D.new(0), fn sales_item, acc ->
            D.add(acc, sales_item.amount)
          end)

        total_qty =
          updated_sales_items
          |> Enum.reduce(D.new(0), fn sales_item, acc ->
            D.add(acc, sales_item.ordered_qty)
          end)

        %{cmd | sales_items: updated_sales_items, total_amount: total_amount, total_qty: total_qty}
      end

      cmd
      |> handle_customer_fn.()
      |> handle_sales_item_fn.()
      |> validator()
    end

    defp validator(cmd) do
      case cmd do
        %{customer_uuid: nil} ->
          {:error, %{customer: "not found"}}

        %{sales_items: sales_items} ->
          sales_items
          |> Enum.all?(fn sales_item -> sales_item.item_uuid != nil && sales_item.ordered_qty > 0 end)
          |> case do
            true -> {:ok, cmd}
            false -> {:error, %{sales_item: "not found"}}
          end

        _ ->
          {:ok, cmd}
      end
    end
  end
end
