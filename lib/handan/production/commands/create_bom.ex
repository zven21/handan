defmodule Handan.Production.Commands.CreateBOM do
  @moduledoc false

  @required_fields ~w(bom_uuid name item_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :bom_uuid, Ecto.UUID
    field :name, :string
    field :item_name, :string
    field :item_uuid, Ecto.UUID

    field :bom_items, {:array, :map}, default: []
    field :bom_processes, {:array, :map}, default: []
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    alias Handan.Stock
    alias Handan.Production
    alias Handan.Production.Commands.CreateBOM

    def enrich(%CreateBOM{item_uuid: item_uuid} = cmd, _) do
      handle_master_item_fn = fn cmd ->
        case Stock.get_item(item_uuid) do
          {:ok, item} ->
            %{cmd | item_name: item.name}

          _ ->
            %{cmd | item_uuid: nil}
        end
      end

      handle_item_fn = fn cmd ->
        updated_items =
          cmd.bom_items
          |> Enum.map(fn entry ->
            case Stock.get_item(entry.item_uuid) do
              {:ok, item} ->
                entry
                |> Map.put(:bom_item_uuid, Ecto.UUID.generate())
                |> Map.put(:item_name, item.name)

              _ ->
                Map.put(entry, :item_uuid, nil)
            end
          end)

        %{cmd | bom_items: updated_items}
      end

      handle_process_fn = fn cmd ->
        updated_processes =
          cmd.bom_processes
          |> Enum.map(fn entry ->
            case Production.get_process(entry.process_uuid) do
              {:ok, process} ->
                entry
                |> Map.put(:bom_process_uuid, Ecto.UUID.generate())
                |> Map.put(:process_name, process.name)

              _ ->
                Map.put(entry, :process_uuid, nil)
            end
          end)

        %{cmd | bom_processes: updated_processes}
      end

      cmd
      |> handle_master_item_fn.()
      |> handle_item_fn.()
      |> handle_process_fn.()
      |> validator()
    end

    defp validator(cmd) do
      case cmd do
        %{item_uuid: nil} ->
          {:error, %{item: "not found"}}

        %{bom_items: items} ->
          items
          |> Enum.all?(fn item -> item.item_uuid != nil end)
          |> case do
            true -> {:ok, cmd}
            false -> {:error, %{item: "not found"}}
          end

        %{bom_processes: processes} ->
          processes
          |> Enum.all?(fn process -> process.process_uuid != nil end)
          |> case do
            true -> {:ok, cmd}
            false -> {:error, %{process: "not found"}}
          end

        _ ->
          {:ok, cmd}
      end
    end
  end
end
