defmodule Handan.Production.Commands.CreateWorkOrder do
  @moduledoc false

  @required_fields ~w(work_order_uuid bom_uuid warehouse_uuid planned_qty)a

  use Handan.EventSourcing.Command

  defcommand do
    field :work_order_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :bom_uuid, Ecto.UUID
    field :item_name, :string
    field :uom_name, :string
    field :code, :string
    field :stock_uom_uuid, Ecto.UUID
    field :warehouse_uuid, Ecto.UUID
    field :planned_qty, :decimal
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :title, :string
    field :supplier_uuid, Ecto.UUID
    field :supplier_name, :string
    field :sales_order_uuid, Ecto.UUID

    # 工单类型
    field :type, Ecto.Enum, values: ~w(sales_order subcontracting produce)a, default: :produce
    field :items, {:array, :map}, default: []
    field :material_request_items, {:array, :map}, default: []
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    import Ecto.Query, warn: false
    import Handan.Infrastructure.DecimalHelper, only: [decimal_mult: 2]

    alias Handan.Production.Commands.CreateWorkOrder
    alias Handan.Production.Projections.BOM

    def enrich(%CreateWorkOrder{work_order_uuid: _work_order_uuid} = cmd, _) do
      handle_bom_fn = fn cmd ->
        case cmd.bom_uuid do
          nil ->
            cmd

          _ ->
            bom = get_bom(cmd.bom_uuid)

            updated_items =
              bom.bom_processes
              |> Enum.map(fn bom_process ->
                %{
                  work_order_item_uuid: Ecto.UUID.generate(),
                  item_name: bom.item_name,
                  item_uuid: bom.item_uuid,
                  work_order_uuid: cmd.work_order_uuid,
                  process_name: bom_process.process_name,
                  process_uuid: bom_process.process_uuid,
                  position: bom_process.position,
                  required_qty: cmd.planned_qty
                }
              end)

            updated_material_request_items =
              bom.bom_items
              |> Enum.map(fn item ->
                %{
                  material_request_item_uuid: Ecto.UUID.generate(),
                  item_name: item.item_name,
                  item_uuid: item.item_uuid,
                  stock_uom_uuid: item.stock_uom_uuid,
                  uom_name: item.uom_name,
                  actual_qty: decimal_mult(cmd.planned_qty, item.qty)
                }
              end)

            %{
              cmd
              | items: updated_items,
                material_request_items: updated_material_request_items,
                item_uuid: bom.item_uuid,
                item_name: bom.item_name,
                stock_uom_uuid: bom.item.default_stock_uom_uuid,
                uom_name: bom.item.default_stock_uom_name
            }
        end
      end

      %{cmd | code: Handan.Infrastructure.Helper.generate_code("WO")}
      |> handle_bom_fn.()
      |> then(&{:ok, &1})
    end

    defp get_bom(bom_uuid) do
      from(b in BOM, where: b.uuid == ^bom_uuid, preload: [:item, :bom_items, :bom_processes], limit: 1)
      |> Handan.Repo.one()
    end
  end
end
