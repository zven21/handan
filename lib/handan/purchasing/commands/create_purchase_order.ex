defmodule Handan.Purchasing.Commands.CreatePurchaseOrder do
  @moduledoc false

  @required_fields ~w(purchase_order_uuid supplier_uuid purchase_items warehouse_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :purchase_order_uuid, Ecto.UUID
    field :supplier_uuid, Ecto.UUID

    field :supplier_name, :string
    field :supplier_address, :string
    field :total_amount, :decimal, default: 0
    field :warehouse_uuid, Ecto.UUID
    field :total_qty, :decimal, default: 0
    field :purchase_items, {:array, :map}
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1, decimal_mult: 2, decimal_add: 2]
    alias Decimal, as: D
    alias Handan.{Stock, Purchasing}
    alias Handan.Purchasing.Commands.CreatePurchaseOrder

    def enrich(%CreatePurchaseOrder{} = cmd, _) do
      handle_supplier_fn = fn cmd ->
        case Purchasing.get_supplier(cmd.supplier_uuid) do
          {:ok, supplier} ->
            %{cmd | supplier_name: supplier.name, supplier_address: supplier.address}

          _ ->
            %{cmd | supplier_uuid: nil}
        end
      end

      handle_purchase_item_fn = fn cmd ->
        updated_purchase_items =
          cmd.purchase_items
          |> Enum.map(fn purchase_item ->
            case Stock.get_item(purchase_item.item_uuid) do
              {:ok, item} ->
                unit_price = Map.get(purchase_item, :unit_price, item.selling_price)

                purchase_item
                |> Map.put_new(:purchase_order_item_uuid, Ecto.UUID.generate())
                |> Map.put(:item_name, item.name)
                |> Map.put(:unit_price, to_decimal(unit_price))
                |> Map.put(:amount, decimal_mult(unit_price, purchase_item.ordered_qty))
                |> Map.put(:purchase_order_uuid, cmd.purchase_order_uuid)

              _ ->
                Map.put(purchase_item, :item_uuid, nil)
            end
          end)

        total_amount =
          updated_purchase_items
          |> Enum.reduce(D.new(0), fn purchase_item, acc ->
            decimal_add(acc, purchase_item.amount)
          end)

        total_qty =
          updated_purchase_items
          |> Enum.reduce(D.new(0), fn purchase_item, acc ->
            decimal_add(acc, purchase_item.ordered_qty)
          end)

        %{cmd | purchase_items: updated_purchase_items, total_amount: total_amount, total_qty: total_qty}
      end

      cmd
      |> handle_supplier_fn.()
      |> handle_purchase_item_fn.()
      |> validator()
    end

    defp validator(cmd) do
      case cmd do
        %{supplier_uuid: nil} ->
          {:error, %{supplier: "not found"}}

        %{purchase_items: purchase_items} ->
          purchase_items
          |> Enum.all?(fn purchase_item -> purchase_item.item_uuid != nil && purchase_item.ordered_qty > 0 end)
          |> case do
            true -> {:ok, cmd}
            false -> {:error, %{purchase_item: "not found"}}
          end

        _ ->
          {:ok, cmd}
      end
    end
  end
end
