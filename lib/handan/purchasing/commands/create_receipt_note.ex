defmodule Handan.Purchasing.Commands.CreateReceiptNote do
  @moduledoc false

  @required_fields ~w(receipt_note_uuid purchase_order_uuid receipt_items)a

  use Handan.EventSourcing.Command

  defcommand do
    field :receipt_note_uuid, Ecto.UUID
    field :purchase_order_uuid, Ecto.UUID

    field :total_qty, :decimal
    field :total_amount, :decimal

    field :supplier_uuid, Ecto.UUID
    field :supplier_name, :string
    field :supplier_address, :string
    field :receipt_items, {:array, :map}
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    import Handan.Infrastructure.DecimalHelper, only: [to_decimal: 1, decimal_add: 2, decimal_mult: 2]

    alias Decimal, as: D
    alias Handan.Purchasing.Commands.CreateReceiptNote

    def enrich(%CreateReceiptNote{} = cmd, _) do
      handle_receipt_item_fn = fn cmd ->
        updated_receipt_items =
          cmd.receipt_items
          |> Enum.map(fn receipt_item ->
            case Handan.Purchasing.get_purchase_order_item(receipt_item.purchase_order_item_uuid) do
              {:ok, purchase_order_item} ->
                if D.gte?(to_decimal(purchase_order_item.remaining_qty), to_decimal(receipt_item.actual_qty)) do
                  receipt_item
                  |> Map.put_new(:receipt_note_item_uuid, Ecto.UUID.generate())
                  |> Map.put(:item_name, purchase_order_item.item_name)
                  |> Map.put(:item_uuid, purchase_order_item.item_uuid)
                  |> Map.put(:receipt_note_uuid, cmd.receipt_note_uuid)
                  |> Map.put(:amount, decimal_mult(receipt_item.actual_qty, purchase_order_item.unit_price))
                  |> Map.put(:stock_uom_uuid, purchase_order_item.stock_uom_uuid)
                  |> Map.put(:uom_name, purchase_order_item.uom_name)
                  |> Map.put(:unit_price, purchase_order_item.unit_price)
                else
                  Map.put(receipt_item, :item_uuid, nil)
                end

              _ ->
                Map.put(receipt_item, :item_uuid, nil)
            end
          end)

        total_qty =
          updated_receipt_items
          |> Enum.reduce(D.new(0), fn receipt_item, acc ->
            decimal_add(acc, receipt_item.actual_qty)
          end)

        total_amount =
          updated_receipt_items
          |> Enum.reduce(D.new(0), fn receipt_item, acc ->
            decimal_add(acc, receipt_item.amount)
          end)

        %{cmd | receipt_items: updated_receipt_items, total_qty: total_qty, total_amount: total_amount}
      end

      cmd
      |> handle_receipt_item_fn.()
      |> validator()
    end

    defp validator(cmd) do
      case cmd do
        %{receipt_items: receipt_items} ->
          receipt_items
          |> Enum.all?(fn receipt_item -> receipt_item.item_uuid != nil end)
          |> case do
            true -> {:ok, cmd}
            false -> {:error, %{receipt_item: "not found"}}
          end

        _ ->
          {:ok, cmd}
      end
    end
  end
end
