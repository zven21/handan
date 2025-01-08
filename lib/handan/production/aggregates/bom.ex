defmodule Handan.Production.Aggregates.BOM do
  @moduledoc false
  @required_fields []

  use Handan.EventSourcing.Type

  deftype do
    field :bom_uuid, Ecto.UUID
    field :item_uuid, Ecto.UUID
    field :item_name, :string
    field :name, :string
    field :deleted?, :boolean, default: false
  end

  alias Handan.Production.Commands.{
    CreateBOM,
    DeleteBOM
  }

  alias Handan.Production.Events.{
    BOMCreated,
    BOMDeleted
  }

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

    bom_evt
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
end
