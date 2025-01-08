defmodule Handan.Production.Commands.CreateBOM do
  @moduledoc false

  @required_fields ~w(bom_uuid name item_uuid)a

  use Handan.EventSourcing.Command

  defcommand do
    field :bom_uuid, Ecto.UUID
    field :name, :string
    field :item_name, :string
    field :item_uuid, Ecto.UUID
  end

  defimpl Handan.EventSourcing.Middleware.Enrichable, for: __MODULE__ do
    alias Handan.Stock
    alias Handan.Production.Commands.CreateBOM

    def enrich(%CreateBOM{item_uuid: item_uuid} = cmd, _) do
      handle_item_fn = fn cmd ->
        case Stock.get_item(item_uuid) do
          {:ok, item} ->
            %{cmd | item_name: item.name}

          _ ->
            %{cmd | item_uuid: nil}
        end
      end

      cmd
      |> handle_item_fn.()
      |> validator()
    end

    defp validator(cmd) do
      case cmd do
        %{item_uuid: nil} ->
          {:error, %{item: "not found"}}

        _ ->
          {:ok, cmd}
      end
    end
  end
end
