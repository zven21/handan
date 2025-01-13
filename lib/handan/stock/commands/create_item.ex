defmodule Handan.Stock.Commands.CreateItem do
  @moduledoc false

  @required_fields ~w(item_uuid name selling_price stock_uoms)a

  use Handan.EventSourcing.Command

  defcommand do
    field :item_uuid, Ecto.UUID
    field :name, :string
    field :spec, :string
    field :description, :string
    field :selling_price, :decimal

    # multi-uoms
    field :stock_uoms, {:array, :map}, default: []
    field :default_stock_uom_name, :string
    field :default_stock_uom_uuid, Ecto.UUID

    # 期初(opening_stocks)
    field :opening_stocks, {:array, :map}, default: []
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    import Ecto.Query, warn: false

    alias Handan.Stock.Commands.CreateItem
    alias Handan.Repo

    def enrich(%CreateItem{} = cmd, _) do
      handle_stock_uoms_fn = fn %{stock_uoms: stock_uoms} = cmd ->
        # stock_uoms = [
        #   %{uom_name: "个", uom_uuid: 1, sequence: 1, conversion_factor: 1},
        #   %{uom_name: "盒", uom_uuid: 2, sequence: 2, conversion_factor: 10},
        #   %{uom_name: "箱", uom_uuid: 3, sequence: 3, conversion_factor: 100}
        # ]
        updated_stock_uoms =
          stock_uoms
          |> Enum.map(fn item ->
            case get_uom(item.uom_uuid) do
              nil ->
                nil

              uom ->
                %{
                  uuid: Ecto.UUID.generate(),
                  item_uuid: cmd.item_uuid,
                  uom_uuid: uom.uuid,
                  uom_name: uom.name,
                  sequence: item.sequence,
                  conversion_factor: item.conversion_factor
                }
            end
          end)
          |> Enum.reject(&is_nil/1)

        default_uom = updated_stock_uoms |> Enum.find(fn item -> item.sequence == 1 end)

        %{cmd | stock_uoms: updated_stock_uoms, default_stock_uom_name: default_uom.uom_name, default_stock_uom_uuid: default_uom.uuid}
      end

      cmd
      |> handle_stock_uoms_fn.()
      |> then(&{:ok, &1})
    end

    defp get_uom(uuid) do
      from(p in Handan.Enterprise.Projections.UOM,
        where: p.uuid == ^uuid
      )
      |> Repo.one()
    end
  end
end
