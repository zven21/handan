defmodule Handan.Production.Commands.CreateProductionPlan do
  @moduledoc false

  @required_fields ~w(plan_uuid name start_date end_date plan_items)a

  use Handan.EventSourcing.Command

  defcommand do
    field :production_plan_uuid, Ecto.UUID
    field :title, :string
    field :start_date, :date
    field :end_date, :date
    field :plan_items, {:array, :map}, default: []
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    alias Handan.Stock
    alias Handan.Production.Commands.CreateProductionPlan

    def enrich(%CreateProductionPlan{production_plan_uuid: _production_plan_uuid} = cmd, _) do
      handle_plan_item_fn = fn cmd ->
        updated_items =
          cmd.plan_items
          |> Enum.map(fn entry ->
            case Stock.get_item(entry.item_uuid) do
              {:ok, item} ->
                entry
                |> Map.put(:production_plan_item_uuid, Ecto.UUID.generate())
                |> Map.put(:item_name, item.name)

              _ ->
                Map.put(entry, :item_uuid, nil)
            end
          end)

        %{cmd | plan_items: updated_items}
      end

      cmd
      |> handle_plan_item_fn.()
      |> validator()
    end

    defp validator(cmd) do
      case cmd do
        %{plan_items: items} ->
          items
          |> Enum.all?(fn item -> item.item_uuid != nil end)
          |> case do
            true -> {:ok, cmd}
            false -> {:error, %{item: "not found"}}
          end

        _ ->
          {:ok, cmd}
      end
    end
  end
end
