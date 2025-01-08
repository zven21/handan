defmodule Handan.Production.Aggregates.BOM do
  @moduledoc false

  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :bom_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :item_name, :string
    field :name, :string

    field :bom_items, :map, default: %{}
    field :bom_processes, :map, default: %{}

    field :deleted?, :boolean, default: false
  end

  alias Handan.Production.Commands.{
    CreateBOM,
    DeleteBOM
  }

  alias Handan.Production.Events.{
    BOMCreated,
    BOMDeleted,
    BOMItemAdded,
    BOMProcessAdded
  }

  alias Handan.Stock.Events.ItemBOMBinded

  def after_event(%BOMDeleted{}), do: :stop
  def after_event(_), do: :timer.hours(1)
  def after_command(_), do: :timer.hours(1)
  def after_error(_), do: :timer.hours(1)

  # 创建BOM
  def execute(%__MODULE__{bom_uuid: nil}, %CreateBOM{} = cmd) do
    bom_evt = %BOMCreated{
      bom_uuid: cmd.bom_uuid,
      item_uuid: cmd.item_uuid,
      item_name: cmd.item_name,
      name: cmd.name
    }

    item_bom_binded_evt = %ItemBOMBinded{
      item_uuid: cmd.item_uuid,
      default_bom_uuid: cmd.bom_uuid
    }

    bom_items_evt =
      cmd.bom_items
      |> Enum.map(fn item ->
        %BOMItemAdded{
          bom_item_uuid: item.bom_item_uuid,
          bom_uuid: cmd.bom_uuid,
          item_uuid: item.item_uuid,
          qty: item.qty,
          item_name: item.item_name
        }
      end)

    bom_processes_evt =
      cmd.bom_processes
      |> Enum.map(fn process ->
        %BOMProcessAdded{
          bom_process_uuid: process.bom_process_uuid,
          bom_uuid: cmd.bom_uuid,
          process_uuid: process.process_uuid,
          process_name: process.process_name,
          position: process.position
        }
      end)

    [bom_evt, bom_items_evt, bom_processes_evt, item_bom_binded_evt] |> List.flatten()
  end

  def execute(_, %CreateBOM{}), do: {:error, :not_allowed}

  # 删除BOM
  def execute(%__MODULE__{bom_uuid: bom_uuid} = _state, %DeleteBOM{bom_uuid: bom_uuid} = _cmd) do
    bom_evt = %BOMDeleted{
      bom_uuid: bom_uuid
    }

    bom_evt
  end

  def execute(_, %DeleteBOM{}), do: {:error, :not_allowed}

  def apply(%__MODULE__{} = state, %BOMCreated{} = evt) do
    %__MODULE__{
      state
      | bom_uuid: evt.bom_uuid,
        item_uuid: evt.item_uuid,
        item_name: evt.item_name,
        name: evt.name
    }
  end

  def apply(%__MODULE__{} = state, %BOMDeleted{} = _evt) do
    %__MODULE__{state | deleted?: true}
  end

  def apply(%__MODULE__{} = state, %BOMItemAdded{} = evt) do
    %__MODULE__{
      state
      | bom_items: Map.put(state.bom_items, evt.bom_item_uuid, evt)
    }
  end

  def apply(%__MODULE__{} = state, %ItemBOMBinded{} = _evt) do
    state
  end

  def apply(%__MODULE__{} = state, %BOMProcessAdded{} = evt) do
    %__MODULE__{
      state
      | bom_processes: Map.put(state.bom_processes, evt.bom_process_uuid, evt)
    }
  end
end
