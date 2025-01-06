defmodule Handan.Stock.Aggregates.Item do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :item_uuid, Ecto.UUID
    field :name, :string
    field :selling_price, :decimal
    field :description, :string
    field :stock_uoms, :map, default: %{}
    field :deleted?, :boolean, default: false
  end

  alias Handan.Stock.Commands.{
    CreateItem,
    DeleteItem
  }

  alias Handan.Stock.Events.{
    ItemCreated,
    ItemDeleted,
    StockUOMCreated
  }

  @doc """
  Stop the item aggregate after it has been deleted
  """
  def after_event(%ItemDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # create item
  def execute(%__MODULE__{item_uuid: nil}, %CreateItem{} = cmd) do
    item_evt = %ItemCreated{
      item_uuid: cmd.item_uuid,
      name: cmd.name,
      selling_price: cmd.selling_price,
      description: cmd.description
    }

    stock_uom_evts =
      cmd.stock_uoms
      |> Enum.map(fn stock_uom ->
        %StockUOMCreated{
          stock_uom_uuid: Ecto.UUID.generate(),
          item_uuid: cmd.item_uuid,
          uom_uuid: stock_uom.uom_uuid,
          uom_name: stock_uom.uom_name,
          conversion_factor: stock_uom.conversion_factor,
          sequence: stock_uom.sequence
        }
      end)

    [item_evt, stock_uom_evts] |> List.flatten()
  end

  def execute(_, %CreateItem{}), do: {:error, :not_allowed}

  def execute(%__MODULE__{item_uuid: item_uuid} = _state, %DeleteItem{item_uuid: item_uuid} = _cmd) do
    %ItemDeleted{
      item_uuid: item_uuid
    }
  end

  def execute(_, %DeleteItem{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %ItemCreated{} = evt) do
    %__MODULE__{
      state
      | item_uuid: evt.item_uuid,
        name: evt.name,
        selling_price: evt.selling_price
    }
  end

  def apply(%__MODULE__{} = state, %ItemDeleted{} = _evt) do
    %__MODULE__{
      state
      | deleted?: true
    }
  end

  def apply(%__MODULE__{} = state, %StockUOMCreated{} = evt) do
    updated_stock_uoms = state.stock_uoms |> Map.put(evt.stock_uom_uuid, Map.from_struct(evt))

    %__MODULE__{
      state
      | stock_uoms: updated_stock_uoms
    }
  end
end
