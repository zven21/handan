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
    field :material_request_items, {:array, :map}, default: []
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    import Ecto.Query, warn: false
    import Handan.Infrastructure.DecimalHelper, only: [decimal_mult: 2]
    alias Handan.Stock
    alias Handan.Production.Projections.BOM
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
                |> Map.put(:bom_uuid, item.default_bom_uuid)

              _ ->
                Map.put(entry, :item_uuid, nil)
            end
          end)

        %{cmd | plan_items: updated_items}
      end

      handle_material_request_item_fn = fn cmd ->
        updated_material_request_items =
          cmd.plan_items
          |> Enum.map(fn plan_item ->
            case is_nil(plan_item.bom_uuid) do
              true ->
                []

              false ->
                bom = get_bom(plan_item.bom_uuid)

                bom.bom_items
                |> Enum.map(fn item ->
                  %{
                    material_request_item_uuid: Ecto.UUID.generate(),
                    item_name: item.item_name,
                    item_uuid: item.item_uuid,
                    stock_uom_uuid: item.stock_uom_uuid,
                    uom_name: item.uom_name,
                    actual_qty: decimal_mult(plan_item.planned_qty, item.qty)
                  }
                end)
            end
          end)
          |> List.flatten()

        %{cmd | material_request_items: updated_material_request_items}
      end

      cmd
      |> handle_plan_item_fn.()
      |> handle_material_request_item_fn.()
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

    defp get_bom(bom_uuid) do
      from(b in BOM, where: b.uuid == ^bom_uuid, preload: [:bom_items], limit: 1)
      |> Handan.Repo.one()
    end
  end
end
